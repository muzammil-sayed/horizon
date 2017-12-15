#!/usr/bin/env python

"""Horizon CLI Tool.

This tool is used to manage and template sets of terraform configurations,
to enable simplified management of multiple AWS accounts and pipeline-phases.
"""

import argparse
import copy
import datetime as dt
from distutils import spawn
import json
import os
import re
import subprocess
import sys
import yaml
import assume_role as ar

TERRAFORM_VERSION = 'v0.9.4'

# TODO: move these constants into a config file
# HORIZON_ROOT is the base directory
HORIZON_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__),
                                            os.pardir))
# list of ENV cars that must be set to run terraform related functions
ENV_VARS = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
# Defaults
REGIONS = ["us-west-2", "eu-central-1"]
GLOBAL_REGION = "us-west-2"
COMPONENTS = ["ipsec"]
INFRA_VARS_CONFIG = os.path.join(HORIZON_ROOT, "horizon.yaml")
GLOBAL_VARS_CONFIG = os.path.join(HORIZON_ROOT, "global.yaml")
TF_BIN = spawn.find_executable("terraform")
TIMESTAMP = dt.datetime.now().strftime("%Y%m%d_%H%M%S")
if os.path.isfile(os.path.join(os.path.expanduser("~"), ".horizon.yaml")):
    CONFIG_DEFAULT = os.path.join(os.path.expanduser("~"), ".horizon.yaml")
else:
    CONFIG_DEFAULT = os.path.join(HORIZON_ROOT, ".horizon.yaml")
# error_retries, number of nonfatal errors that can be encounted by TF
# before the entire run is aborted
ERROR_RETRIES = 3
# list of recoverable terraform errors
TF_RECOVERABLE_ERRORS = ["diffs didn't match during apply."]


def parse_options():
    """Parse CLI arguments and return an object with the options."""
    parser = argparse.ArgumentParser(
        description='Creates or updates account specific environments in AWS.')

    parser.add_argument(
        '-A', '--tf_action',
        default='plan',
        help="The terraform action to run: apply, plan or destroy. \
                  Defaults to plan"
    )
    parser.add_argument(
        '-v', '--verbose',
        action='store_true',
        help="print verbose output"
    )
    parser.add_argument(
        '-d', '--debug',
        action='store_true',
        help="print debugging output"
    )
    parser.add_argument(
        '-B', '--tf_bin',
        default=TF_BIN,
        help="The abs path to the terraform binary you wish to use \
                  Defaults to {}.".format(TF_BIN)
    )

    args_group = parser.add_argument_group('Arguments')
    args_group.add_argument(
        '-e', '--env',
        help="The identifier for the environment's template and default files."
    )
    args_group.add_argument(
        '-a', '--account',
        help="The specific account to make changes against. The name should match \
              the directory name found in templates. For example, 'soa_core'."
    )
    args_group.add_argument(
        '-n', '--infra_vpc_name',
        help="The name of the infra VPC associated with this account."
    )
    args_group.add_argument(
        '-c', '--component_vpc',
        action='store_true',
        default=False,
        help="If set, only runs the tf_action for the vpc and network infra \
              and not for the app components"
    )
    args_group.add_argument(
        '-i', '--infra_vpc',
        action='store_true',
        default=False,
        help="If set, creates an infra VPC (bastions hosts, etc).  \
              If this is set then the --component_vpc flag is implied"
    )
    args_group.add_argument(
        '-g', '--apply_global',
        action='store_true',
        default=False,
        help="If set, creates global resources in first defined region. \
              First default region is {}".format(REGIONS[0])
    )
    args_group.add_argument(
        '-p', '--components',
        nargs='+',
        default=COMPONENTS,
        help="Run against a space separated list of apps (chime daily etc) \
              Defaults to {}.".format(COMPONENTS)
    )
    args_group.add_argument(
        '--regions',
        nargs='+',
        default=REGIONS,
        help="Run against a space separated list of regions. \
              Defaults to: {}".format(' '.join(REGIONS))
    )
    args_group.add_argument(
        '-r', '--assume-role',
        help="Use centralized IAM creds, and assume a role to manage the account. \
              Valid options are: administrator"
    )

    alias_group = parser.add_argument_group('Alias')
    alias_group.add_argument(
        '-f', '--config_file',
        default=CONFIG_DEFAULT,
        help="user specific config file"
    )
    alias_group.add_argument(
        '-l', '--alias',
        help="command alias"
    )
    alias_group.add_argument(
        '--search',
        help="Search aliases"
    )
    options = parser.parse_args()

    # Search defined aliases
    if options.search:
        search_results = []
        with open(options.config_file, 'r') as stream:
            try:
                alias_config = yaml.load(stream)
                for key in alias_config.keys():
                    if options.search in key:
                        search_results.append(key)
            except yaml.YAMLError as exc:
                print(exc)
        if len(search_results) > 0:
            print "Search results: "
            for item in search_results:
                print item
        else:
            print "Search string not found."

        exit(0)

    # Rebuild the options based on the alias specified
    if options.alias:
        with open(options.config_file, 'r') as stream:
            try:
                alias_config = yaml.load(stream)
                alias_config[options.alias] += " -A " + options.tf_action
                alias_config[options.alias] += " -B " + options.tf_bin
                if options.verbose:
                    alias_config[options.alias] += " -v "
                if options.debug:
                    alias_config[options.alias] += " -d "

                options = parser.parse_args(
                    alias_config[options.alias].split())
            except KeyError as exc:
                print "Error: The alias \"{}\" does not exist".format(
                    options.alias)
                sys.exit(1)
            except yaml.YAMLError as exc:
                print exc
                sys.exit(1)

    # Check for required arguments
    if not (options.env and options.account):
        print "Required options missing: "
        print "Env: " + str(options.env)
        print "Account: " + str(options.account)
        sys.exit(1)

    # If args.infra true then set args.vpc to true as the run should only be
    # for a VPC
    if options.infra_vpc:
        options.component_vpc = True

    # The IAM globals should only be applied to the Infra VPC.
    if options.apply_global and not options.infra_vpc:
        print "IAM globals can only be applied to the Infra VPC. Use the '-i'"\
            "flag and input the infra VPC name."
        sys.exit(1)

    return options


def check_terraform_version(tf_bin):
    """Check Terraform binary version.

    Ensure that the version of terraform being used matches our expected
    version.
    """
    version_pattern = re.compile(".* (v\d\S*)")
    version_output = subprocess.check_output([tf_bin, '-version'])
    version_match = version_pattern.match(version_output)

    if not version_match:
        error_msg = ("Unable to find Terraform version in:\n{}".format(
                                                            version_output))
        sys.exit(error_msg)

    installed_version = version_match.group(1)

    if installed_version != TERRAFORM_VERSION:
        error_msg = ("Unable to validate Terraform version ({}).\n\n"
                     "Expected: {}, Found: {}".format(tf_bin,
                                                      TERRAFORM_VERSION,
                                                      installed_version))
        sys.exit(error_msg)

    return


def copy_dir_structure(source, target):
    """Create the directory structure.

    Using the source dir and the target dir, create the working directory
    structure. Also, calls symlink_mirror to mirror files as symlinks
    """
    symlink_mirror(source, target)
    source_dirs = [d for d in os.listdir(source)
                   if os.path.isdir(os.path.join(source, d))]
    for subdir in source_dirs:
        source_path = os.path.join(source, subdir)
        target_path = os.path.join(target, subdir)
        # Check to see if subdir exists in target else create it
        if not os.path.exists(target_path):
            os.makedirs(target_path)
        # remove any exisiting symlinks to clean up
        symlink_clean(target_path)
        # mirror symlinks from source dir to target dir
        symlink_mirror(source_path, target_path)
        # copy_dir_structure for each subdir
        copy_dir_structure(source_path, target_path)


def symlink_mirror(source, target):
    """Create symlinks in the target dir to files in the source dir."""
    try:
        source_files = [f for f in os.listdir(source)
                        if os.path.isfile(os.path.join(source, f))]
    except OSError:
        sys.exit("ERROR: Unable to open source directory: {}".format(source))

    for sfile in source_files:
        source_abs = os.path.join(source, sfile)
        target_abs = os.path.join(target, sfile)
        # notify, and remove file if one exists before symlinking
        if os.path.exists(target_abs) and not os.path.islink(target_abs):
            error_msg = "WARNING: symlinking files in env" \
                        " directory failed due to" \
                        " pre-existing file: {}".format(target_abs)
            print(error_msg)
            os.remove(target_abs)
            error_msg = "Removed pre-existing file to allow for symlinking\n\n"
            print(error_msg)
        if not os.path.exists(target_abs):
            os.symlink(source_abs, target_abs)


def symlink_clean(directory):
    """Remove all symlinks in directory."""
    symlinks = [f for f in os.listdir(directory)
                if os.path.islink(os.path.join(directory, f))]
    for symlink in symlinks:
        os.remove(os.path.join(directory, symlink))


def create_env_skeleton(environment, env_dir, templates_dir):
    """Create directory structure and create necessary symlinks for env."""
    # Check if env toplevel dir exists and if not create it
    tl_dir_path = os.path.join(env_dir, environment)
    if not os.path.exists(tl_dir_path):
        os.makedirs(tl_dir_path)
    # Copy dir structure found in the templates dir to the new env tl dir
    # Also mirrors files in source as symlink in target
    copy_dir_structure(templates_dir, tl_dir_path)
    return tl_dir_path


def check_env_vars():
    """Check to make sure the env vars are set and if not exits with error."""
    for env_var in ENV_VARS:
        if os.environ.get(env_var) is None:
            error_msg = "{} environment var must be set".format(env_var)
            sys.exit(error_msg)


def get_defaults_files(defaults_dir, environment, region, component,
                       infra_vpc):
    """Build a list of all defaults files that match our rules."""
    defaults_parser = re.compile(r"(({0}|all)."
                                 r"({1}|all)."
                                 r"({2}|all)."
                                 r"vars|({0}|{3}|all)"
                                 r".global.all.vars)".format(environment,
                                                             region,
                                                             component,
                                                             infra_vpc))

    files = []
    for defaults_file in os.listdir(defaults_dir):
        if not os.path.isfile(os.path.join(defaults_dir, defaults_file)):
            continue
        if defaults_parser.match(defaults_file):
            files.append(defaults_file)

    return files


def build_tfvars_contents(defaults_dir, defaults_files, environment, region):
    """Concatenate the corresponding account and region defaults_files.

    Append all the variables in the default_files, as well as the environment
    and region variables.
    """
    tfvars = []
    tfvars.append('env = "' + environment + '"')
    tfvars.append('region = "' + region + '"')
    for defaults_file in defaults_files:
        path = os.path.join(defaults_dir, defaults_file)
        with open(path) as d_file:
            tfvars.append(d_file.read())
    # Add empty item to make sure newline is added to last real item
    tfvars.append("")

    return "\n".join(tfvars)


def create_tfvars(environment, component, tfvars_path, region, defaults_dir,
                  infra_vpc):
    """Create a terraform.tfvars file in the component's dir.

    It is generated from files in the defaults dir, which match our definition:
      <environment|all>.<region|all>.<component|all>.vars
      <environment|infra_vpc|all>.global.all.vars
    """
    defaults_files = get_defaults_files(defaults_dir, environment,
                                        region, component, infra_vpc)
    tfvars_contents = build_tfvars_contents(defaults_dir, defaults_files,
                                            environment, region)
    with open(tfvars_path, 'w') as tfvars_file:
        tfvars_file.write(tfvars_contents)


def manage_terraform(options, tf_dir, region, defaults_dir, log_dir):
    """Manage running and error handling for terraform.

    Will check to see if any errors encountered are recoverable by running
    terraform again. If so terrafrom will be run again.
    """
    check_env_vars()
    environment = options.env
    tf_action = options.tf_action
    infra_vpc = options.infra_vpc_name
    # The name of the dir will give us the component
    component = os.path.basename(tf_dir)
    log_name_prefix = "{}.{}.{}.terraform.{}.".format(region, environment,
                                                      component,
                                                      tf_action.upper())
    # Initalize a dict to keep track of errors generated by TF
    error_counter = {}
    # Initalize counter used to keep track of TF runs
    tf_run_count = 0
    # create the tfvars file, unless it's a destroy action
    if tf_action != "destroy":
        tfvars_path = os.path.join(tf_dir, "terraform.tfvars")
        create_tfvars(environment, component, tfvars_path, region,
                      defaults_dir, infra_vpc)
    # If the action is apply then run a plan first
    if tf_action == "apply":
        print "Running PLAN before the APPLY for {} {}".format(component,
                                                               region)
        plan_options = copy.copy(options)
        plan_options.tf_action = "plan"
        manage_terraform(plan_options, tf_dir, region, defaults_dir, log_dir)
    # continue to run terrafrom until stopped
    run_tf = True
    while run_tf:
        tf_run_count += 1
        # determine logfile path
        log_file_name = log_name_prefix + TIMESTAMP + "." + str(tf_run_count)
        log_file_path = os.path.join(log_dir, log_file_name)
        print("Terraform {} run {} for {} in {}".format(tf_action.upper(),
                                                        tf_run_count,
                                                        component, region))
        tf_errors = run_terraform(options, tf_dir, component, log_file_path,
                                  region)
        # if tf_errors is empty, means run went well and we can break the loop
        if len(tf_errors) == 0:
            print("Terraform {} run {} for {} in {} completed "
                  "with no errors".format(tf_action.upper(),
                                          tf_run_count, component, region))
            break
        else:
            print("Terraform {} run {} for {} in {} completed "
                  "with some errors".format(tf_action.upper(),
                                            tf_run_count, component, region))
        # for each tf_error, see if it's recoverable, if so add a counter
        # for the error so we don't look forever in the case something
        # really isn't recoverable
        for error in tf_errors:
            for recoverable_error in TF_RECOVERABLE_ERRORS:
                if recoverable_error in error:
                    resource = error.split(" ")[1]
                    key = (resource, recoverable_error)
                    if key in error_counter:
                        error_counter[key] += 1
                    else:
                        error_counter[key] = 1
                    # If match an recoverable_error no need to continue
                    break
                else:
                    error_msg = ("Terraform {} had a fatal issue. "
                                 "Check {} log file for details.").format(
                                     tf_action, log_file_path)
                    sys.exit(error_msg)
        # check if any of the counters is greater then the  number of allowed
        # retries if so error and exit, otherwise loop again
        for error_type in error_counter:
            if error_counter[error_type] >= ERROR_RETRIES:
                resource = error_type[0]
                error = error_type[1]
                error_msg = ("{} has encountered too many '{}' errors".format(
                    resource, error))
                sys.exit(error_msg)


def run_terraform(options, tf_dir, component, log_file_path, region):
    """Run terraform with the supplied action.

    Terraform plan will be run before any other action to esnure everything
    is good to go. Returns a list of encountered errors (or an empty list).
    """
    # init list that will be returnd
    tf_bin = options.tf_bin
    tf_action = options.tf_action
    verbose = options.verbose
    debug = options.debug
    error_lines = []
    # If action is destroy include the -force arg so no confirm prompt
    if tf_action == "destroy":
        tf_cmd = [tf_bin, tf_action, "-force"]
    else:
        tf_cmd = [tf_bin, tf_action]

    if not os.path.exists(os.path.dirname(log_file_path)):
        os.makedirs(os.path.dirname(log_file_path))

    with open(log_file_path, 'w+') as logfile:
        if debug:
            print "DEBUG: cwd - {}".format(tf_dir)
            print "DEBUG: exec - {}".format(' '.join(tf_cmd))
        proc = subprocess.Popen(tf_cmd, cwd=tf_dir, stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT)
        while proc.poll() is None:
            line = proc.stdout.readline()
            if verbose:
                print line.strip()
            logfile.write(line)
        if proc.returncode:
            # go back to begining of the logfile to look for error msgs
            logfile.seek(0)
            for line in logfile:
                if "error(s) occurred:" in line:
                    # use regex to find error number in line
                    pattern = "[0-9]* error\(s\)"
                    re_match = re.search(pattern, line)
                    # get number of errors we are looking for
                    number_of_errors = int(re_match.group(0).split(" ")[0])
                    # Next line is always blank so skip
                    logfile.next()
                    while len(error_lines) < number_of_errors:
                        log_line = logfile.next()
                        if log_line.startswith("* "):
                            error_lines.append(log_line)
                        break
    return error_lines


def get_default_attribute_value(resource_dict, resource, attribute):
    """Populate default values.

    Get the default value for an attribute of a resource in a resource_dict
    from a tfstate file.
    """
    resource_path = resource_dict[resource]
    attribute_path = resource_path['primary']['attributes']
    value = attribute_path[attribute]
    return value


def create_global_vars(tfstate_file_path, global_vars_dest, defaults_dir):
    """Create an global_vars.tf file.

    Similar to create_app_vars(), but this creates the global_vars.tf file
    for each of variables listed in the global terraform.tfstate file.
    """
    global_vars = []

    # Open and read the yaml config file and create dict from contents
    with open(GLOBAL_VARS_CONFIG) as config_file:
        config = yaml.safe_load(config_file)

    # Open and append entries from the account-specific global.yaml file
    account_config_file = os.path.join(defaults_dir, "global.yaml")
    if os.path.isfile(account_config_file):
        with open(account_config_file) as ac_file:
            account_config = yaml.safe_load(ac_file)
            config.update(account_config)

    # Open, read and create dict from terraform.tfstate file
    # if this is run before --apply_global has been run, it will error out
    try:
        with open(tfstate_file_path) as tfstate_file:
            tfstate_file_contents = tfstate_file.read()
            tfstate = json.loads(tfstate_file_contents)
    except IOError:
        error_msg = ("Unable to access {} for the vpc. "
                     "This is likley caused by not running horizon.py "
                     "with the --apply_global flag first.".format(
                                                        tfstate_file_path))
        sys.exit(error_msg)

    resource_dict = tfstate['modules'][0]['resources']
    global_vars_path = os.path.join(global_vars_dest, "global_vars.tf")

    # Cycle through config and create terraform var for each item
    for resource_name, items in config.iteritems():
        global_vars.append('variable "{}" {{'.format(
            resource_name.replace('.', '_')))
        global_vars.append('    description = "{}"'.format(
            items['description']))
        attribute = items['attribute']
        # Look in resource_dict for resource_name and
        # create a list of any matches
        resources = [resource for resource in resource_dict
                     if (resource.startswith(resource_name + ".")) or
                     (resource == resource_name)]
        # create a map if more than one resource is found that start
        # with the resource_name
        resource_count = len(resources)
        if resource_count == 0:
            error_msg = ("Error when trying to create {}. "
                         "unable to find key: {}. "
                         "This could be because the infra hasn't been created "
                         "and you need to run an apply with the "
                         "--component_vpc option. OR it could be that the "
                         "entry in the config yaml file is wrong").format(
                                                            global_vars_path,
                                                            resource_name)
            sys.exit(error_msg)
        elif resource_count == 1:
            # single default
            default_value = get_default_attribute_value(resource_dict,
                                                        resource_name,
                                                        attribute)
            global_vars.append('    default = "{}"'.format(default_value))
        else:
            # make a map
            global_vars.append('    default = {')
            for resource in resources:
                default_value = get_default_attribute_value(resource_dict,
                                                            resource,
                                                            attribute)
                map_key = "key" + resource.split(".")[-1]
                global_vars.append('        {} = "{}"'.format(map_key,
                                                              default_value))
            global_vars.append("    }")
        global_vars.append("}\n")

    global_vars_str = "\n".join(global_vars)
    with open(global_vars_path, 'w') as global_vars_file:
        global_vars_file.write(global_vars_str)


def create_app_vars(infra_path, app_path, defaults_dir):
    """Create an infra_vars.tf file.

    Load the horizon.yaml config file and the infra terraform.tfstate.
    This is used to provide infra details that can be used when building
    the app components.
    """
    # Create list to hold the var definitions that will be written to file
    infra_vars = []

    # Open and read the yaml config file and create dict from contents
    with open(INFRA_VARS_CONFIG) as config_file:
        config = yaml.safe_load(config_file)

    # Open and append entries from the account-specific horizon.yaml file
    account_config_file = os.path.join(defaults_dir, "horizon.yaml")
    if os.path.isfile(account_config_file):
        with open(account_config_file) as ac_file:
            account_config = yaml.safe_load(ac_file)
            config.update(account_config)

    # Open, read and create dict from terraform.tfstate file
    tfstate_file_path = os.path.join(infra_path, "terraform.tfstate")
    # if this is run before the infra has been built it will error out
    # if this is the case send message stating first run must be with
    # --component_vpc flag
    try:
        with open(tfstate_file_path) as tfstate_file:
            tfstate_file_contents = tfstate_file.read()
            tfstate = json.loads(tfstate_file_contents)
    except IOError:
        error_msg = ("Unable to access terraform.tfstate for the vpc. "
                     "This is likley caused by not running horizon.py "
                     "with the --component_vpc flag first.")
        sys.exit(error_msg)

    resource_dict = tfstate['modules'][0]['resources']
    infra_vars_path = os.path.join(app_path, "infra_vars.tf")

    # Cycle through config and create terraform var for each item
    for resource_name, items in config.iteritems():
        infra_vars.append('variable "{}" {{'.format(
            resource_name.replace('.', '_')))
        infra_vars.append('    description = "{}"'.format(
            items['description']))
        attribute = items['attribute']
        # Look in resource_dict for resource_name and
        # create a list of any matches
        resources = [resource for resource in resource_dict
                     if (resource.startswith(resource_name + ".")) or
                     (resource == resource_name)]
        # create a map if more than one resource is found that start
        # with the resource_name
        resource_count = len(resources)
        if resource_count == 0:
            # If a resource doesn't exist, use the 'mock' value if present.
            #
            # This enables having shared app_vars defined in templates which
            # may not be used in some cases (e.g. if a shared variable is in a
            # resource with count=0, the variable still needs to exist or
            # terraform will fail with 'unknown variable', even if it's not
            # needed)
            try:
                infra_vars.append('    default = "{}"'.format(items['mock']))
            except KeyError:
                error_msg = ("Error when trying to create {}. "
                             "unable to find key: {}. "
                             "This could be because the infra hasn't been "
                             "created and you need to run an apply with the "
                             "--component_vpc option. OR it could be that the "
                             "entry in the config yaml file is wrong").format(
                                 infra_vars_path,
                                 resource_name)
                sys.exit(error_msg)
        elif resource_count == 1:
            # single default
            default_value = get_default_attribute_value(resource_dict,
                                                        resource_name,
                                                        attribute)
            infra_vars.append('    default = "{}"'.format(default_value))
        else:
            # make a map
            infra_vars.append('    default = {')
            for resource in resources:
                default_value = get_default_attribute_value(resource_dict,
                                                            resource,
                                                            attribute)
                map_key = "key" + resource.split(".")[-1]
                infra_vars.append('        {} = "{}"'.format(map_key,
                                                             default_value))
            infra_vars.append("    }")
        infra_vars.append("}\n")

    infra_vars_str = "\n".join(infra_vars)
    with open(infra_vars_path, 'w') as infra_vars_file:
        infra_vars_file.write(infra_vars_str)


def banner(message):
    """Show account and regions being affected."""
    print "\n################################"
    print message
    print "################################"


def main():
    """Parse CLI arguments, construct env tree, and execute terraform."""
    options = parse_options()
    account = options.account

    check_terraform_version(options.tf_bin)

    # Directory defaults
    log_dir = os.path.join(HORIZON_ROOT, "logs", account)
    templates_dir = os.path.join(HORIZON_ROOT, "templates", account)

    # Switch to the appropriate role, if that's how we do it
    defaults_dir = os.path.join(HORIZON_ROOT, "defaults", account)
    if options.assume_role:
        ar.assume_role(defaults_dir, options.assume_role,
                       options.infra_vpc_name, account,
                       options.verbose)

    # Apply all resources from the "global" directory in us-west-2
    if options.apply_global:
        region = GLOBAL_REGION
        os.environ["AWS_DEFAULT_REGION"] = region

        banner("Setting IAM defaults for {} in {}".format(
            account, os.environ.get("AWS_DEFAULT_REGION")))

        env_dir = os.path.join(HORIZON_ROOT, "env", account, region)
        env_path = create_env_skeleton(options.env, env_dir, templates_dir)
        infra_path = os.path.join(env_path, "global")

        manage_terraform(options, infra_path, region, defaults_dir, log_dir)

    # Create the dir and file structure for the env
    else:
        for region in options.regions:
            os.environ["AWS_DEFAULT_REGION"] = region

            banner("{} in {}".format(account,
                                     os.environ.get("AWS_DEFAULT_REGION")))

            env_dir = os.path.join(HORIZON_ROOT, "env", account, region)
            env_path = create_env_skeleton(options.env, env_dir, templates_dir)
            # If -infra_vpc is set then use TF files for infra VPC
            # Otherwise use files for the app VPC
            if options.infra_vpc:
                infra_path = os.path.join(env_path, "infra_vpc")
            else:
                infra_path = os.path.join(env_path, "component_vpc")

            # If the TF actions is NOT destroy, then do the action against the
            # infra first and then the app. If it is destroy, then the opposite
            global_env_dir = os.path.join(HORIZON_ROOT, "env", account,
                                          GLOBAL_REGION)
            global_vars_origin = os.path.join(global_env_dir,
                                              options.infra_vpc_name,
                                              "global", "terraform.tfstate")

            if options.tf_action != "destroy":
                # Run terraform against the infra if the infra flag is set
                if options.component_vpc:
                    if options.infra_vpc:
                        global_vars_dest = os.path.join(env_dir, options.env,
                                                        "infra_vpc")
                    else:
                        global_vars_dest = os.path.join(env_dir, options.env,
                                                        "component_vpc")
                        infra_vpc_path = os.path.join(env_dir,
                                                      options.infra_vpc_name,
                                                      "infra_vpc")
                        app_path = os.path.join(env_path, "component_vpc")
                        create_app_vars(infra_vpc_path, app_path, defaults_dir)

                    create_global_vars(global_vars_origin, global_vars_dest,
                                       defaults_dir)
                    manage_terraform(options, infra_path, region, defaults_dir,
                                     log_dir)
                    # Otherwise just run terraform against the components
                else:
                    for component in options.components:
                        app_path = os.path.join(env_path, "components",
                                                component)
                        create_app_vars(infra_path, app_path, defaults_dir)
                        global_vars_dest = os.path.join(env_dir, options.env,
                                                        "components",
                                                        component)
                        create_global_vars(global_vars_origin,
                                           global_vars_dest,
                                           defaults_dir)
                        manage_terraform(options, app_path, region,
                                         defaults_dir, log_dir)
            # Run a Terrafrom destroy
            else:
                # Run terraform against the infra if the infra flag is set
                if options.component_vpc:
                    if options.infra_vpc:
                        global_vars_dest = os.path.join(env_dir, options.env,
                                                        "infra_vpc")
                    else:
                        global_vars_dest = os.path.join(env_dir, options.env,
                                                        "component_vpc")
                        infra_vpc_path = os.path.join(env_dir,
                                                      options.infra_vpc_name,
                                                      "infra_vpc")
                        app_path = os.path.join(env_path, "component_vpc")
                        create_app_vars(infra_vpc_path, app_path, defaults_dir)

                    create_global_vars(global_vars_origin, global_vars_dest,
                                       defaults_dir)
                    manage_terraform(options, infra_path, region, defaults_dir,
                                     log_dir)
                    # Otherwise just run terraform against the apps componets
                else:
                    for component in options.components:
                        app_path = os.path.join(env_path, "components",
                                                component)
                        create_app_vars(infra_path, app_path, defaults_dir)
                        global_vars_dest = os.path.join(env_dir, options.env,
                                                        "components",
                                                        component)
                        create_global_vars(global_vars_origin,
                                           global_vars_dest,
                                           defaults_dir)
                        manage_terraform(options, app_path, region,
                                         defaults_dir, log_dir)

if __name__ == '__main__':
    main()

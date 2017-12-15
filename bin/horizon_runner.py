#!/usr/bin/env python

"""Horizon runner

Run Horizon against multiple environments
"""

import os
import argparse
import yaml
import time
from subprocess import call


# Variables
CONFIG_FILE_DEFAULT = os.path.join(os.path.expanduser("~"), ".horizon.yaml")
HORIZON_BINARY = os.path.join(os.path.expanduser("~"),
                              "git/jive/code/horizon/bin/horizon")

# Pull in args
parser = argparse.ArgumentParser(
    description='Run horizon against multiple environments')
parser.add_argument(
    '-f', '--config_file',
    default=CONFIG_FILE_DEFAULT,
    help='User config file containing aliases.  '
         'Default: ' + CONFIG_FILE_DEFAULT
)
parser.add_argument(
    '-A', '--tf_action',
    default='plan',
    help="The terraform action to run: apply, plan or destroy. \
          Defaults to plan"
)
parser.add_argument(
    '-r', '--horizon',
    default=HORIZON_BINARY,
    help="Horizon executable to use.  Default: " + HORIZON_BINARY
)
parser.add_argument(
    '-c', '--cont',
    action='store_true',
    help="Continue execution after failure.  Default: False"
)
parser.add_argument(
    'aliases',
    nargs='*',
    help="Aliases to run horizon against"
)
parser.add_argument(
    '--search',
    help="Search defined aliases"
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

report = {}

# Loop through all the included
for alias in options.aliases:

    with open(options.config_file, 'r') as stream:
        try:
            # Slurp the aliases file
            alias_config = yaml.load(stream)
            stream.close()

            # Add the specified action to the command
            alias_config[alias] += " -A " + options.tf_action

            # Build the command line
            command_list = []
            command_list.append(options.horizon)
            command_list.extend(alias_config[alias].split())

            # give the user a chance to bail out
            print "Running " + " ".join(command_list)
            time.sleep(2)

            return_code = call(command_list)
            if return_code != 0:
                print "Error running terraform"
                if not options.cont:
                    print "Exiting..."
                    exit(1)
                report[alias] = "FAILED"
            else:
                report[alias] = "SUCCESS"

        except yaml.YAMLError as exc:
            print(exc)
            exit(1)

        except KeyError as exc:
            print "Alias not found: " + alias
            exit(1)

# Print out a report of the activity
print "#############################"
print "Job Report:"
for key in report.keys():
    print key + ": " + report[key]

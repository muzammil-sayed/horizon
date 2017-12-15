#!/usr/bin/env python

"""
This script will attempt to assume a specified role and return a SessionToken.
Roles ARNs are derived from the aws_account_id defined in the inferred
defaults file:

    horizon/terraform/defaults/<account>/<infra_vpc>.global.all.vars

Finally, SessionToken will expire after 15 minutes.
"""

import os
import re
import sys
import boto3
import botocore


def assume_role(iam_roles_path, role, infra_vpc, account, verbose):
    """Generate an AWS assume-role token and export os environment variables with the content."""
    creds = get_token(iam_roles_path, role, infra_vpc, account, verbose)

    os.environ['AWS_ACCESS_KEY_ID'] = creds['Credentials']['AccessKeyId']
    os.environ['AWS_SECRET_ACCESS_KEY'] = creds['Credentials']['SecretAccessKey']
    os.environ['AWS_SESSION_TOKEN'] = creds['Credentials']['SessionToken']


def get_account_id(defaults_path, infra_vpc):
    """Get the account_id from the global defaults file."""

    defaults_file = os.path.join(defaults_path, "{}.global.all.vars".format(infra_vpc))
    with open(defaults_file) as dfile:
        for line in dfile:
            if line.startswith("aws_account_id"):
                aws_account_id = re.search(r"aws_account_id = \"(\w+)\"$", line).group(1)
                break

    return aws_account_id


def get_token(defaults_path, role, infra_vpc, account, verbose):
    """obtains an AssumeRole token for the given role"""

    account_id = get_account_id(defaults_path, infra_vpc)
    role_arn = "arn:aws:iam::{}:role/{}".format(account_id, role)
    session_name = "{}-{}".format(account, infra_vpc)

    if verbose:
        print "assuming role: {}".format(role_arn)

    try:
        client = boto3.client('sts')
        token = client.assume_role(
            RoleArn=role_arn,
            RoleSessionName=session_name,
            DurationSeconds=900
        )
        return token

    except botocore.exceptions.ClientError as client_error:
        error_message = "ERROR: Unable to get SessionToken for:\n\n" \
            "role: {}\ninfra_vpc: {}\naccount: {}\nrole_arn: {}\n" \
            "\n{}".format(role, infra_vpc, account, role_arn, client_error)
        sys.stderr.write(error_message)
        sys.exit(1)

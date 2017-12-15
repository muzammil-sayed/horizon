#!/usr/bin/env python
"""Takes an AWS Secret Key as input, and converts it to an SES SMTP password.

This is required in order to use AWS SES:
  https://docs.aws.amazon.com/ses/latest/DeveloperGuide/smtp-credentials.html

"""

import base64
import hmac
import hashlib
import sys


def hash_smtp_pass_from_secret_key(key):
    """convert a secret key to an SES SMTP password"""
    message = "SendRawEmail"
    version = '\x02'
    ses_hash = hmac.new(key, message, digestmod=hashlib.sha256)

    return base64.b64encode("{0}{1}".format(version, ses_hash.digest()))

if __name__ == "__main__":
    print hash_smtp_pass_from_secret_key(sys.argv[1])

# Okta Setup Procedure

The following process covers the steps involved with configuring Okta for AWS
accounts which have been created using the
[AWS Account Creation](https://brewspace.jiveland.com/docs/DOC-268873) doc.


## Prerequisite

* Base IAM Resources created (via process in [Adding a new account](./add_account.md)

## Create access keys for the okta IAM user
    1. [Sign in to AWS](https://console.aws.amazon.com), using root credentials
    2. The `okta` user should already exist, create an access key for it
    3. Note the credentials
        * _TIP: just leave the browser window open for now_


## Create AWS application in Okta, and download IDP metadata
    1. https://jive.okta.com
    2. Admin -> Applications -> Add Application -> Amazon Web Services -> Add
        1. General
            * Application label: AWS - <account_name> <phase>
            * Use defaults for remaining settings
        2. Sign-On Options
            * Select SAML 2.0
                * Click the link for "Identity Provider metatdata", to download the metadata.xml file
                * Move the downloaded file to: `templates/<account_name>/global/okta/<aws_account_short_name>-saml-metadata.xml`
            * Enter the following info
                * Access key: blank
                * Identity provider ARN: arn:aws:iam::<account_id>:saml-provider/okta
                    * _TIP: your terminal buffer should have the <account_id> listed in the 'assuming role: ...' ARN_
                * Secret key: blank
            * Use defaults for remaining settings, and click Next
        2. STOP HERE in the Okta UI. The AWS side needs to be configured before continuing.


## Create Okta saml provider in AWS
    1. `cp -rp templates/base_template/okta/{okta,okta-saml.tf} templates/<account_name>/global/`
        * _NOTE: if you previously removed these files, put the old ones back in place now instead_
    2. `horizon -A apply -a <account_name> -e infra-<phase> -n infra-<phase> -i -v -r administrator --apply_global`


## FINISH: Add AWS application to Okta
    1. Continue on from the previous Add Application workflow
        1. Provisioning
            * Select: Enable provisioning features
            * Access key: previously created key
            * Secret key: previously created key
            * Create Users: Enable
        2. Assign to People
            1. Assign it to everyone on the IAAS team, using the okta-administrator role
            1. Assign to other users, if known and approved

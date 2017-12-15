# Adding a new account

The following process covers all steps involved with bootstrapping a set of new
AWS accounts, which have been created using the
[AWS Account Creation](https://brewspace.jiveland.com/docs/DOC-268873) doc.


# Prerequisites

* Initial AWS accounts created, according to [AWS Account Creation](https://brewspace.jiveland.com/docs/DOC-268873)
* Consolidated billing setup complete


# Base Horizon Setup
1. Create defaults files:
    * `cp defaults/base_template/infra-*.global.all.vars defaults/<account_name>/`
    * Edit `defaults/<account_name>/infra-*.global.all.vars`, change:
        * `aws_account_short_name`: account name
        * `aws_account_id`: account ID
2. Copy base templates into place:
    * `mkdir templates/<account_name>`
    * `cp -rp templates/base_template/global templates/<account_name>/`


# Configure the governor account
1. create IAM groups and policies for the new accounts
    * add to `templates/governor/global/iam_groups_administrator.tf`
    * add to `templates/governor/global/iam_groups_poweruser.tf`
    * add to `templates/governor/global/iam_groups_readonly.tf`
2. create group-memberships for users of the account
    * add to `templates/governor/global/iam_memberships_administrator.tf`
    * add to `templates/governor/global/iam_memberships_poweruser.tf`
    * add to `templates/governor/global/iam_memberships_readonly.tf`
3. apply config
    * `horizon -A apply -a governor -e infra-pipeline -n infra-pipeline -i -v -r administrator --apply_global`

# Configure the infra account
1. add new account account ID to S3 accounts list
    * add new account arn into `templates/infra/global/ansible-s3.tf` for both ansible and ansible_coreos policies
2. apply config
    * `horizon -A apply -a infra -e infra-pipeline -n infra-pipeline -i -v -r administrator --apply_global`
    * `horizon -A apply -a infra -e infra-brewprod -n infra-brewprod -i -v -r administrator --apply_global`
    * `horizon -A apply -a infra -e infra-prod -n infra-prod -i -v -r administrator --apply_global`

# Create `bootstrap` credentials
For each account (pipeline, brewprod, prod):
1. [Sign in to AWS](https://console.aws.amazon.com), using root credentials
2. Create `bootstrap` policy, copy *AdministratorAccess* policy document
3. Create `bootstrap` user, save credentials
4. Attach `bootstrap` policy to `bootstrap` user
5. Generate access key for `bootstrap` user


# Create Base IAM Resources
**For each account (pipeline, brewprod, prod):**
1. Setup base IAM resources on the account
    1. Source `bootstrap` credentials for the account in your terminal
        * `export AWS_ACCESS_KEY_ID=<access key id from generation step>`
        * `export AWS_SECRET_ACCESS_KEY=<secret from generation step>`
    2. Validate the credentials/permissions
        * `aws iam get-user --user-name bootstrap`
            * Verify the <account_id> in the ARN
    3. Apply base account configuration
        * `horizon -A apply -a <account_name> -e infra-<phase> -n infra-<phase> -i -v --apply_global`
            * _NOTE: if you run into issues around to okta metadata, it is likely due to
                having completed the bootstrap process on one of the other accounts in the set._
            * To workaround the issue, temporarily remove the following file and rerun horizon:
                * `templates/<account_name>/global/okta-saml.tf`
2. Verify that your cross-account user/credentials work with horizon on this account
    1. Source governor credentials
    2. Validate that horizon can use the cross-account-role
        * `horizon -A plan -a <account_name> -e infra-<phase> -n infra-<phase> -i -v -r administrator --apply_global`
        * _NOTE: there should be no changes_


# Destroy Bootstrap Credentials
**For each account (pipeline, brewprod, prod):**
1. [Sign in to AWS](https://console.aws.amazon.com), using root credentials
2. Delete `bootstrap` policy
3. Delete `bootstrap` user

# Request required limit increases
1. [Sign in to AWS](https://console.aws.amazon.com), using root credentials
2. Check BS doc for a list of limits to increase: [AWS limit increases](https://brewspace.jiveland.com/docs/DOC-285131)
2. Open a support case to increase limits
    * Support -> Support Center -> Create case
        * Select Service Limit Increase
        * Change Limit Type to VPC
        * Create a request for each region

# Okta Setup
**For each account (pipeline, brewprod, prod):**
1. Go through the [Okta Setup Procedure](./okta.md)


# Infrastructure VPC Setup
1. Create an LDAP group for each account: `<account_name>`
    * Create an IAAS jira and submit for approval
    * Once approved, create the LDAP groups
        * Initial members should be the team the accounts are being created for
2. Manually create and upload an ssh key pair for each account
    * _NOTE: doing this via terraform will store the private keys in the tfstate files, which we want to avoid, so it's manual for now._
    * Generate a new key pair, on your workstation
        * `ssh-keygen -t rsa -b 2048 -f <account_name>.pem -C <account_name>`
    * Save private key in passwordstate
        * Under the documents tab, in the password list for the account: [AWS/AWS - EC2 SSH Keys/ACCOUNT_NAME](https://passwordstate.eng.jiveland.com)
        * Note: if a password list for the account doesn't exist, it will need to be created
    * Import key pair via AWS Console
        * EC2 -> Key Paris -> Import Key Pair
        * Choose file: `<account_name>.pem.pub`
        * Key pair name: `<account_name>`
3. Accept the CentOS 7 AMI license for each account
    * Currently: [CentOS 7 HVM](http://aws.amazon.com/marketplace/pp?sku=aw0evgkw8e5c1q413zgy5pjce)
    * NOTE: Do **not** launch an instance with One Click
4. Update infra and component VPC subnets
    * Obtain CIDR ranges for the infra and component VPCs and regions
        * _NOTE: some accounts have pre-allocated CIDR ranges documented [here](https://brewspace.jiveland.com/docs/DOC-285060)_
    * `cp defaults/base_template/infra.region.all.vars defaults/<account_name>/infra-<phase>.<region>.all.vars`
        * Update `cidr.*` ranges
        * Update `bastion_ip`, should typically be x.x.x.7
        * Update `bastion_keypair`, use the name of the key you just uploaded
5. Put the base infra_vpc templates in place
    * _NOTE: this only needs to be done once, and covers all accounts_
    * `cp -r templates/base_template/infra_vpc templates/<account_name>/`
6. Run Horizon to setup us-west-2
    * _NOTE: do we have to run it several times???_
    * `horizon -A apply -e infra-<phase> -a <account_name> -n infra-<phase> -i -v -r administrator --apply_global`
    * Edit `defaults/<account_name>/<phase>.global.all.vars`, change:
        * `route53_zone_id`: get route53_zone_id for the Route53 private domain zone via AWS Console
    * `horizon -A apply -e infra-<phase> -a <account_name> -n infra-<phase> -i -v -r administrator --regions us-west-2`
    * [VPC Peering connections](#component_route) are created when the component VPCs are built
        * Subsequent Horizon runs against the infra VPC will ignore route changes to routing tables to preserve peer connection routes
        * To make changes to the infra VPC routing tables, comment out the lifecycle code block from routing table resource templates:
            * `lifecycle {ignore_changes = ["route"]}`
            * Once the new routes have been added, uncomment the lifecycle block
            * Horizon needs to be run against the [component VPCs](#component_vpc) to re-add peer connection routes
    * Add entries for each `<phase>` in the `<account_name>` to `execution_manifest.yaml`
7. Additional Bastion setup
    * Setup DNS for the bastion
        * Add a route53 record for the host in the 'infra-prod' account, using Horizon
    * Setup the bastion for Ansible deploys
        * Update the ansible-deploy Rundeck project in Puppet
            * Add an entry for it to modules/rundeck_jive/files/projects/ansible-deploy/resources.yaml
    * Add the bastion to the list in the [Bastion Runbook](https://brewspace.jiveland.com/docs/DOC-257834)


# Direct Connect Setup (currently for us-west-2 only)
1. Go through the [VPC Direct Connect Setup Procedures](https://brewspace.jiveland.com/docs/DOC-286053), for each of the infra-<phase> VPCs.
2. Bastion host validation
    * Once the Firewall setup is complete, verify that you can connect to each bastion host


# VPN Setup (currently for eu-central-1 and any other regions without direct connects in place)
1. Request a public IP address from the Network team.  You will need one for each VPN connection you plan to create.  An example Jira is [here](https://jira.jivesoftware.com/browse/IAAS-6142)
    * _NOTE: some accounts have pre-allocated ip addresses for vpn use. Check [here](https://brewspace.jiveland.com/docs/DOC-285060) first before requesting addresses_
2. Uncomment the phx_vpn.tf file in the vpc directory where you want to create the vpn (typically templates/{account}/infra_vpc or templates/{account}/component_vpc)
3. In the defaults for this account/region, add the following lines:
    * `# PHX VPN`
    * `phx_vpn_ip = "{IP assigned by Networking team}"`
    * `condition.eu_central = 1'`
4. Run horizon to create the VPN in the infra_vpc:
    * `horizon -A plan -a {account} -e {environment} -n infra-{environment} -i -v -r administrator --regions eu-central-1`

    Or in the component_vpc:
    * `horizon -A plan -a {account} -e {environment} -n infra-{environment} -c -v -r administrator --regions eu-central-1`
5. Once the VPN link is created, download the aws-generated config for the VPN for "Juniper J-series" type device and upload it to the Jira you created. Include the name of the VPC and the 10.x subnet being used for it.
    * If the config generated uses an IP address that is already in use on another VPN connection, use this workaround to force a new IP address assignment: (https://aws.amazon.com/articles/5458758371599914)


# Component VPCs
1. Go through the [Component VPC Setup Procedures](./component_vpc.md), for each <phase> that requires a VPC.


# Create Components
1. TODO: Create some example component files under base_template/components/example

# Component VPCs

Component VPCs support the non-infrastructure resources that live in a set of
accounts.

> "This is where the magic happens." -- MTV Cribs

The standard component_vpc's support the following environments: integ, test,
release, brewprod, and prod

The component_vpc templates are common across the environments (making it
simple to have many similar environments), while the defaults/vars are unique
to each environment - enabling the deployment of smaller, or fewer hosts in one
environment, and more and larger hosts in another.

Because VPCs don't span regions, each component_vpc is also limited to a single
region.

**For each environment and region that will get a component_vpc:**

1. Create the defaults file
    * You should have previously obtained CIDR ranges, if not get them now.
        * _NOTE: some accounts have pre-allocated CIDR ranges documented [here](https://brewspace.jiveland.com/docs/DOC-285060)_
    * `cp defaults/base_template/component.region.all.vars defaults/<account_name>/<environment>.<region>.all.vars`
        * Update `cidr.*` ranges
        * Update `bastion_cidr`: bastion IP address in CIDR by:
            * Checking `infra-<phase>.<region>.all.vars` defaults file
        * Update `infra_vpc_id`: get from console by navigating to:
            * VPC -> Virtual Private Gateways
            * VPC ID of `infra-<phase>-vpc`
2. Populate component_vpc templates (note: only needed for the first component_vpc created in an account)
    * `cp -r templates/base_template/component_vpc templates/<account_name>/`
4. Run Horizon to create <a name="component_vpc">component VPCs</a>
    * `horizon -A apply -a <account_name> -e <environment> -n <infra_vpc> -c -r administrator -v --regions us-west-2`
    * A <a name="component_route">VPC Peering connection</a> will be created between the component VPC and the infra VPC
        * Routes will be added to the infra VPC routing tables to allow peer traffic
        * if VPC Peering connections are created between two separate AWS accounts, you will need to manually "Accept [the creation] Request" on the AWS Console of the accounts (likely the second / newer account of the two)
    * Update `execution_manifest.yaml`, to add an entry to the appropriate account/phase that includes this horizon command.
5. Go through the [VPC Direct Connect Setup Procedures](https://brewspace.jiveland.com/docs/DOC-286053), for each of the VPCs (if they're in us-west-2. Other regions utilize VPN).
6. Validate networking
    * Define a test EC2 instance
        * `mkdir templates/<account>/components`
        * `cp -r templates/base_template/components/test templates/<account>/components`
        * Edit `templates/<account>/components/test/test_node.sh`, and set key_name to the appropriate `<account>-<phase>` value
    * Run horizon to create the resource
        * `horizon -A apply -a <account_name> -e <environment> -n <infra_vpc> -p test -r administrator -v --regions us-west-2`
    * Connect to the EC2 instance
        * `ssh bastion-<account_name>.prod.jivehosted.com`
        * `ssh test-node.jiveprivate.com`
    * Destroy the EC2 instance
        * `horizon -A destroy -a <account_name> -e <environment> -n <infra_vpc> -p test -r administrator -v --regions us-west-2`
        * `rm -r templates/<account>/components/test`

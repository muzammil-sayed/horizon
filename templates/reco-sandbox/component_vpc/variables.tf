variable "aws_account_short_name" {
  description = "The short name for the aws account. For example if the account name was jive-aws-pipeline, then the shortname would be pipeline"
}

variable "aws_account_id" {
  description = "The account Id fo the target AWS account"
}

variable "env" {
  description = "The target environment"
}

variable "region" {
  description = "The target AWS region"
}

variable "sla" {
  description = "The SLA related to the resource"
}

variable "az" {
  description = "mapping of AZ number or AWS AZ identifier. This may need to be changed in the case a region other than us-west-2 is used"

  default = {
    az1 = "a"
    az2 = "b"
    az3 = "c"
  }
}

variable "az_count" {
  description = "The number of AZ's in the given region."
}

variable "cidr" {
  description = "CIDRs assignments"

  default = {
    vpc              = ""
    natdc-subnet-1   = ""
    natdc-subnet-2   = ""
    natdc-subnet-3   = ""
    public-subnet-1  = ""
    public-subnet-2  = ""
    public-subnet-3  = ""
    private-subnet-1 = ""
    private-subnet-2 = ""
    private-subnet-3 = ""
  }
}

variable "nat_asg" {
  description = "The number of NAT ASGs to create for an environment. 1 or 3 are the only options that make sense"
}

variable "infra_vpc_id" {
  description = "VPC ID of the infra VPC that manages this VPC"
}

variable "bastion_cidr" {
  description = "CIDR block of the bastion hosts used to manage instances within this VPC, likley a /32"
}

variable "route53_zone_id" {
  description = "Global private DNS zone"
}

variable "condition" {
  description = "Count for conditional creation of resources"

  default = {
    build_vpn = 0
  }
}

variable "jive_vpn_ip" {
  description = "Jive DC external gateway IP address for VPNs"
}

variable "vpn_customer_gateway" {
  description = "Customer gateway"
}

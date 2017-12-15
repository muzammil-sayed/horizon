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
    az1 = ""
    az2 = ""
    az3 = ""
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

variable "bastion_keypair" {
  description = "keypair to be used for the bastion instance"
}

variable "bastion_ami" {
  description = "ami to be used for the bastion instance"
}

variable "bastion_instance_type" {
  description = "instance to be used for the bastion instance"
}

variable "bastion_instance_volume_size" {
  description = "size of the EBS volume attached to the bastion instance"
}

variable "bastion_ip_addr" {
  description = "IP address of the bastion instance"
}

variable "private_domain" {
  description = "Domain for Jive instances"
}

variable "route53_zone_id" {
  description = "Global private DNS zone"
}

variable "jive_service" {
  description = "The service name"
  default     = "infrastructure"
}

variable "condition_vpn" {
  description = "Count for conditional creation of resources"

  default = {
    build_vpn = 0
  }
}

variable "condition_corp_vpn" {
  description = "Build toggle for corp VPN"

  default = {
    build_corp_vpn   = 0
  }
}

variable "condition" {
  description = "Count for conditional creation of resources"

  default = {
    build_vpn      = 0
    build_ams_vpn  = 0
  }
}

variable "condition_corp_vpn" {
  description = "Build toggle for corp VPN"

  default = {
    build_corp_vpn   = 0
  }
}

variable "jive_vpn_ip" {
  description = "Jive DC external gateway IP address for VPNs"
  default     = ""
}

variable "jive_vpn_bgp_asn" {
  description = "Jive DC BGP ASN for dynamic routing, set to 65000 (or other bogus number) for static routes"
  default     = 13364
}

variable "jive_corp_vpn_ip" {
  description = "Jive Corp external gateway IP address for VPNs"
  default     = ""
}

variable "jive_corp_vpn_bgp_asn" {
  description = "Jive Corp BGP ASN for dynamic routing, set to 65000 (or other bogus number) for static routes"
  default     = 65000
}

variable "jive_corp_vpn_static_routes_only" {
  description = "Whether or not to only use static routes for Corp VPNs (set to true when BGP is not in use)"
  default     = true
}

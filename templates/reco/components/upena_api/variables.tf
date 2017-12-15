variable "env" {
  description = "The target environment"
}

variable "jive_service" {
  description = "The service name"
  default     = "upena"
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

variable "bastion_cidr" {
  description = "CIDR block of the bastion hosts used to manage instances within this VPC, likely a /32"
}

variable "private_domain" {
  description = "Domain for POC instances"
}

variable "route53_zone_id" {
  description = "Global private DNS zone"
}

variable "upena_s3_bucket" {
  description = "The target s3 bucket for upena scripts"
}

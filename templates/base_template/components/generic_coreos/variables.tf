variable "env" {
  description = "The target environment"
}

variable "region" {
  description = "The target AWS region"
}

variable "jive_service" {
  description = "The name of the service"
  default     = "k8s"
}

variable "sla" {
  description = "The SLA related to the resource"
}

variable "aws_account_short_name" {
  description = "The short name of the AWS account"
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

variable "route53_zone_id" {
  description = "Global private DNS zone"
}

variable "az" {
  description = "mapping of AZ number or AWS AZ identifier. This may need to be changed in the case a region other than us-west-2 is used"

  default = {
    az1 = "a"
    az2 = "b"
    az3 = "c"
  }
}

variable "coreos_ami" {
  default = "ami-9f46e7ff"
}

variable "coreos_instance_type" {
  default = "t2.micro"
}

variable "coreos_keypair" {
  default = "infra-pipeline"
}

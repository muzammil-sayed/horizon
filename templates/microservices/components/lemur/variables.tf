variable "env" {
  description = "The target environment"
}

variable "region" {
  description = "The target AWS region"
}

variable "jive_service" {
  description = "The name of the service"
  default     = "lemur"
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

variable "lemur_ami" {
  description = "AMI for lemur coreos instances"
}

variable "lemur_instance_type" {
  description = "Instance type for lemur instance"
}

variable "lemur_instance_count" {
  description = "Instance count for lemur instance"
}

variable "lemur_keypair" {
  description = "Keypair for lemur instance"
}

variable "lemur_instance_volume_size" {
  description = "Lemur instance volume size"
}

variable "lemur_instance_root_volume_size" {
  description = "Lemur instance root volume size"
}

variable "lemur_asg_min" {
  description = "Minimum ASG count for lemur instance"
}

variable "lemur_asg_max" {
  description = "Maximum ASG count for lemur instance"
}

variable "lemur_db_instance_type" {
  description = "Instance type for lemur DB"
}

variable "lemur_db_username" {
  description = "Username used for lemur DB"
}

variable "lemur_db_password" {
  description = "Password used for lemur DB"
}

variable "lemur_db_volume_size" {
  description = "Lemur DB volume size"
}

variable "lemur_db_iops" {
  description = "DB IOPS of lemur db"
}

variable "az" {
  description = "mapping of AZ number or AWS AZ identifier. This may need to be changed in the case a region other than us-west-2 is used"

  default = {
    az1 = "a"
    az2 = "b"
    az3 = "c"
  }
}

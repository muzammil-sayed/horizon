variable "env" {
  description = "The target environment"
}

variable "region" {
  description = "The target AWS region"
}

variable "jive_service" {
  description = "The name of the service"
  default     = "tardis"
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

variable "k8s_ami" {
  description = "AMI for k8s coreos instances"
}

variable "tardis_instance_type" {
  description = "Instance type for tardis"
}

variable "tardis_instance_count" {
  description = "Instance count for tardis"
}

variable "tardis_keypair" {
  description = "keypair for tardis instances"
}

variable "tardis_instance_volume_size" {
  description = "tardis instances volume size"
}

variable "tardis_asg_min" {
  description = "Minimum ASG count for tardis"
}

variable "tardis_asg_max" {
  description = "Minimum ASG count for tardis"
}

variable "az" {
  description = "mapping of AZ number or AWS AZ identifier. This may need to be changed in the case a region other than us-west-2 is used"

  default = {
    az1 = "a"
  }
}

variable "kube_extra_id" {
  description = "Extra identifier for kubernetes clusters"
}

variable "coreos_authkey" {
  description = "Authorized key for the coreos nodes"
}

variable "docker_registry" {
  description = "The Docker registry endpoint set in /etc/hosts"
}

variable "phx_pulp" {
  description = "The PHX Pulp server set in /etc/hosts"
}

variable "ansible_bucket" {
  description = "The S3 bucket which contains the cluster_manifest.json and ansible bootstrap script"
}

variable "tardis_security_group" {
  description = "Security group for the tardis nodes"
  default = ""
}

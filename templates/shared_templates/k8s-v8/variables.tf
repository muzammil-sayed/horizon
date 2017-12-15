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

variable "k8s_ami" {
  description = "AMI for k8s coreos instances"
}

variable "k8s_master_instance_type" {
  description = "Instance type for k8s master"
}

variable "k8s_master_instance_count" {
  description = "Instance count for k8s master"
}

variable "k8s_master_keypair" {
  description = "keypair for k8s master instances"
}

variable "k8s_master_instance_volume_size" {
  description = "k8s master instances volume size"
}

variable "k8s_master_asg_min" {
  description = "Minimum ASG count for k8s master"
}

variable "k8s_master_asg_max" {
  description = "Maximum ASG count for k8s master"
}

variable "k8s_worker_instance_type" {
  description = "Instance type for k8s workers"
}

variable "k8s_worker_instance_count" {
  description = "Instance count for k8s woker"
}

variable "k8s_worker_keypair" {
  description = "keypair for k8s worker instances"
}

variable "k8s_worker_instance_volume_size" {
  description = "k8s worker instances volume size"
}

variable "k8s_worker_asg_min" {
  description = "Minimum ASG count for k8s workers"
}

variable "k8s_worker_asg_max" {
  description = "Maximum ASG count for k8s workers"
}

variable "k8s_etcd_instance_type" {
  description = "Instance type for k8s etcd"
}

variable "k8s_etcd_instance_count" {
  description = "Instance count for k8s etcd"
}

variable "k8s_etcd_keypair" {
  description = "keypair for k8s etcd instances"
}

variable "k8s_etcd_instance_volume_size" {
  description = "k8s etcd instances volume size"
}

variable "k8s_etcd_asg_min" {
  description = "Minimum ASG count for k8s etcd"
}

variable "k8s_etcd_asg_max" {
  description = "Minimum ASG count for k8s etcd"
}

variable "az" {
  description = "mapping of AZ number or AWS AZ identifier. This may need to be changed in the case a region other than us-west-2 is used"

  default = {
    az1 = "a"
    az2 = "b"
    az3 = "c"
  }
}

variable "kube_extra_id" {
  description = "Extra identifier for kubernetes clusters"
}

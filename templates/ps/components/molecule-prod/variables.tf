variable "env" {
  description = "The target environment"
}

variable "region" {
  description = "The target AWS region"
}

variable "aws_account_short_name" {
  description = "The short name of the AWS account"
}

variable "molecule_keypair" {
  description = "The name of the molecule key pair"
}

variable "elb_cert_arn" {
  description = "ELB SSL certificate ARN"
}

variable "molecule_type" {
  description = "Boomi molecule type (prod or test)"
}

variable "molecule_min_size" {
  description = "Molecule auto scale group minimum"
}

variable "molecule_max_size" {
  description = "Molecule auto scale group maximum"
}

variable "molecule_target_size" {
  description = "Molecule auto scale group target"
}

variable "molecule_ami" {
  description = "ami to be used for molecule instances"
}

variable "molecule_sla" {
  description = "SLA to be used for molecule instances"
}

variable "molecule_instance_type" {
  description = "Test or prod"
}

variable "molecule_volume_size" {
  description = "Size of encrypted volume where molecule is installed"
}

variable "az" {
  description = "mapping of AZ number or AWS AZ identifier. This may need to be changed in the case a region other than us-west-2 is used"

  default = {
    az1 = "a"
    az2 = "b"
    az3 = "c"
  }
}

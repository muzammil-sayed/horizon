variable "env" {
    description = "The target environment"
}

variable "region" {
    description = "The target AWS region"
}

variable "sample_ami" {
    description = "ami to be used for sample instances"
}

variable "sample_instance_type" {
    description = "instance to be used for sample instances"
}

variable "sample_keypair" {
    description = "keypair to be used for sample instances"
} 

variable "sample_elb_cert" {
    description = "ARN of the cert to be used for on the ELB"
}

variable "aws_account_short_name" {
  description = "The short name of the AWS account"
}


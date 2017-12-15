variable "upena_keypair" {
  description = "keypair"
}

variable "aws_account_short_name" {
  description = "The short name of the AWS account"
}

variable "region" {
  description = "separates upena cluster in the same account"
}

variable "upena___TYPE___ami" {
  description = "ami to be used for upena___TYPE__ instances"
}

variable "upena___TYPE___instance_ebs_optimized" {
  description = "ebs_optimized"
  default = "false"
}

variable "upena___TYPE___volume_size" {
  description = "size of the EBS volume attached to the upena___TYPE__ instances"
}

variable "upena___TYPE___volume_type" {
  description = "type of the EBS volume attached to the upena___TYPE__ instances"
  default = "st1"
}

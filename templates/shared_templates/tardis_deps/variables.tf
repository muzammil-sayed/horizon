variable "env" {
  description = "The target environment"
}

variable "region" {
  description = "The target AWS region"
}

variable "aws_account_short_name" {
  description = "The short name of the AWS account"
}

variable "kube_extra_id" {
  description = "Extra identifier for kubernetes clusters"
}

variable "tardis_security_group" {
  description = "Security group for the tardis nodes"
  default = ""
}

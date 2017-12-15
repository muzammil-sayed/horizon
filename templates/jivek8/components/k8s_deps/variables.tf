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

variable "kube_extra_id" {
  description = "Extra identifier for kubernetes clusters"
}

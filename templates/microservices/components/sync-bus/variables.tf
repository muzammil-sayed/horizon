variable "aws_account_short_name" {
  description = "The short name for the aws account. For example if the account name was jive-aws-pipeline, then the shortname would be pipeline"
}

variable "aws_account_id" {
  description = "The ID of the aws account."
}

variable "env" {
  description = "The target environment"
}

variable "region" {
  description = "The target AWS region"
}

variable "mako_env" {
  description = "The corresponding Mako environment name"
  default = {
    pipeline = "ms-integ"
    brewprod = "ms-brewprod"
    prod     = "ms-prod"
  }
}

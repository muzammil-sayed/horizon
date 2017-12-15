variable "aws_account_short_name" {
  description = "The short name for the aws account. For example if the account name was jive-aws-pipeline, then the shortname would be pipeline"
}

variable "region" {
  description = "The target AWS region"
}

variable "upena_s3_bucket" {
  description = "The target s3 bucket for upena bin scripts."
}

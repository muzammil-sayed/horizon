variable "aws_account_short_name" {
  description = "The short name for the aws account. For example if the account name was jive-aws-pipeline, then the shortname would be pipeline"
}

variable "aws_account_id" {
  description = "The account Id fo the target AWS account"
}

variable "governor_account_arn" {
  description = "The ARN of the governor account for cross account roles"
}

variable "env" {
  description = "The target environment"
}

variable "region" {
  description = "The target AWS region"
}

variable "sla" {
  description = "The SLA related to the resource"
}

variable "private_domain" {
  description = "Domain for Jive instances"
}

#variable "private_dns_zone_id" {


#    description = "Private DNS zone"


#}


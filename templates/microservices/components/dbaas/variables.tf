variable "env" {
  description = "The target environment"
}

variable "region" {
  description = "The target AWS region"
}

variable "jive_service" {
  description = "The name of the service"
  default     = "DBaaS"
}

variable "sla" {
  description = "The SLA related to the resource"
}

variable "aws_account_short_name" {
  description = "The short name for the aws account. For example if the account name was jive-aws-pipeline, then the shortname would be pipeline"
}
variable "aws_account_short_name" {
  description = "The short name for the aws account. For example if the account name was jive-aws-pipeline, then the shortname would be pipeline"
}

variable "aws_account_id" {
  description = "The ID of the aws account."
}

variable "env" {
  description = "The target environment"
}

variable "mako_env" {
  description = "The corresponding Mako environment name"
}

variable "jive_service" {
  description = "The name of the service"
  default     = "emailservice"
}

variable "sla" {
  description = "The SLA related to the resource"
}

variable "az_count" {
  description = "Total count of availability zones"
}

variable "region" {
  description = "The target AWS region"
}

variable "aurora_instance_type" {
  description = "The instance type of an Aurora node"
}

variable "aurora_username" {
  description = "The master username associated with the Aurora instance"
}

variable "aurora_password" {
  description = "The master password associated with the Aurora instance"
}

variable "aurora_db_name" {
  description = "The name of the Aurora database"
}

variable "identity_cache_cluster_id" {
  description = "The name of the Elasticache Redis cluster."
}

variable "identity_cache_instance_type" {
  description = "The type of the Elasticache Redis instance."
}

variable "identity_cache_nodes" {
  description = "The number of Elasticache Redis instances."
}

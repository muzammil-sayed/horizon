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
  default     = "sync-core"
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


variable "postgres_instance_type" {
  description = "The instance type of an Aurora node"
}

variable "postgres_username" {
  description = "The master username associated with the postgres instance"
}

variable "postgres_password" {
  description = "The master password associated with the postgres instance"
}

variable "postgres_db_name" {
  description = "The name of the postgres database"

}

  variable "postgres_subnet_name" {
    description = "The name of the postgres subnet"

}

variable "postgres_parameter_group" {
  description = "The name of the postgres parameter group"

}

variable "postgres_instance_identifier" {
  description = "The name of the postgres instance"

}



variable "postgres_instance_count" {
description="Numbers of Postgres instances for identity"


}

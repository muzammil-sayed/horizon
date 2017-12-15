variable "env" {}
variable "jive_service" {}

variable "bastion_cidr" {}
variable "default_rds_subnet_group" {}

variable "identity_postgres_instance_type" {}
variable "identity_postgres_db_name" {}
variable "identity_postgres_username" {}
variable "identity_postgres_password" {}

variable "identity_default_postgres_instance_identifier" {}
variable "identity_default_pg_alocated_storage" {}

variable "identity_migration_postgres_instance_identifier" {}
variable "identity_migration_pg_alocated_storage" {}

variable "identity_ingress_cidr_blocks" {}

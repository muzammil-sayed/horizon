variable "env" {}
variable "jive_service" {}

variable "jiveprivate_zone_id" {}

variable "default_rds_subnet_group" {}
variable "default_elasticache_subnet_group" {}

variable "bastion_cidr" {}

variable "conversation_ami" {}
variable "conversation_keypair" {}
variable "conversation_ebs_optimized" {}

variable "conversation_connector_instance_type" {}
variable "conversation_connector_instance_count" {}

variable "conversation_postgres_instance_type" {}
variable "conversation_postgres_db_name" {}
variable "conversation_postgres_username" {}
variable "conversation_postgres_password" {}
variable "conversation_postgres_instance_identifier" {}
variable "conversation_postgres_allocated_storage" {}

variable "conversation_cache_cluster_id" {}
variable "conversation_cache_instance_type" {}
variable "conversation_cache_nodes" {}
variable "presence_cache_cluster_id" {}
variable "presence_cache_instance_type" {}
variable "presence_cache_nodes" {}

variable "conversation_ingress_cidr_blocks" {}

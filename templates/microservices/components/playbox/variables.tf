variable "env" {}
variable "jive_service" {}

variable "jiveprivate_zone_id" {}

variable "pipeline_inst_sg" {}
variable "infra_pipeline_inst_sg" {}

variable "playbox_ami" {}
variable "playbox_keypair" {}

variable "playbox_mongodb_data_instance_type" {}
variable "playbox_mongodb_data_instance_count" {}
variable "playbox_mongodb_data_volume_size" {}
variable "playbox_ebs_optimized" {}

variable "playbox_mongodb_config_instance_type" {}
variable "playbox_mongodb_config_instance_count" {}

variable "playbox_redis_instance_type" {}
variable "playbox_redis_instance_count" {}



variable "playbox_zookeeper_instance_type" {}
variable "playbox_zookeeper_instance_count" {}
variable "playbox_zookeeper_volume_size" {}

variable "playbox_nimbus_instance_type" {}
variable "playbox_nimbus_instance_count" {}

variable "playbox_supervisor_instance_type" {}
variable "playbox_supervisor_instance_count" {}

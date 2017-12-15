variable "aws_account_short_name" {}

variable "region" {}

variable "sla" {}

variable "ec2_key_name" {}

variable "component" { default = "blammo" }

variable "env" { default = "pipeline" }

variable "jive_service" { default = "devo" }

variable "jive_service_short_name" { default = "devo" }

variable "route53_zone_id" { description = "Global private DNS zone" }

variable "route53_private_data_zone_id" { default = "Z3AIHK7L8DPDVB" }

variable "route53_public_data_zone_id" { default = "ZHGVEY1FG7YK9" }

variable "instance_size" { default = "m1.small" }

variable "ebs_volume_size" { default = "1024" }

variable "ami_id" { default = "ami-0c2aba6c" } # Centos 7 HVM Official EBS

variable "uswesta_vpc_subnet_id" { default = "subnet-cde823bb" }

variable "uswestb_vpc_subnet_id" { default = "subnet-5d42f439" }

variable "uswestc_vpc_subnet_id" { default = "subnet-ece5feb5" }

variable "elasticsearch_instance_size" { default = "r3.xlarge" }

variable "kafka_instance_size" { default = "c3.large" }

variable "kibana_instance_size" { default = "c3.large" }

variable "logstash_instance_size" { default = "t2.medium" }
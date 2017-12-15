variable "aws_account_short_name" {}

variable "region" {}

variable "sla" {}

variable "ec2_key_name" {}

variable "component" { default = "blammo" }

variable "env" { default = "pipeline" }

variable "jive_service" { default = "devo" }

variable "jive_service_short_name" { default = "devo" }

variable "route53_zone_id" { description = "Global private DNS zone" }

variable "route53_private_data_zone_id" { default = "ZC46QDQ3D8IG" }

variable "route53_public_data_zone_id" { default = "Z2X7G552BDO908" }

variable "instance_size" { default = "m1.small" }

variable "ebs_volume_size" { default = "1024" }

variable "ami_id" { default = "ami-4d6a467d" } # Rightimage Centos 7.0 PV, Instance Store

variable "uswesta_vpc_subnet_id" { default = "subnet-cde823bb" }

variable "uswestb_vpc_subnet_id" { default = "subnet-5d42f439" }

variable "uswestc_vpc_subnet_id" { default = "subnet-ece5feb5" }

variable "elasticsearch_instance_size" { default = "i3.large" }

variable "kafka_instance_size" { default = "m1.small" }

variable "kibana_instance_size" { default = "c3.large" }

# variable "kafka_secure_ingress" { default = "9093" }

# variable "kafka_insdataecure_ingress" { default = "9092" }

# variable "kibana_http" { default = "5601" }

# variable "elasticseach_http" { default = "9200" }

# variable "elasticsearch_transport" { default = "9300" }
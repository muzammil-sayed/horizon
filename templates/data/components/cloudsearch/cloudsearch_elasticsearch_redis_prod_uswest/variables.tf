variable "aws_account_short_name" {}

variable "region" {}

variable "sla" {}

variable "ec2_key_name" {}

# { default = "data-brewprod" }

variable "component" { default = "elasticsearch" }

variable "env" { default = "dataprodor" }

variable "jive_service" { default = "cloudsearch" }

variable "jive_service_short_name" { default = "search" }

variable "route53_zone_id" { description = "Global private DNS zone" }

variable "route53_data_zone_id" { default = "ZC46QDQ3D8IG" }

variable "route53_dataprodor_zone_id" { default = "Z2X7G552BDO908" }

variable "instance_size" { default = "r4.large" }

variable "ebs_volume_size" { default = "8192" }

variable "ami_id" { default = "ami-d2c924b2" }

variable "uswesta_vpc_subnet_id" { default = "subnet-ef59e88b" }

variable "uswestb_vpc_subnet_id" { default = "subnet-97d913e1" }

variable "uswestc_vpc_subnet_id" { default = "subnet-9dcad0c4" }
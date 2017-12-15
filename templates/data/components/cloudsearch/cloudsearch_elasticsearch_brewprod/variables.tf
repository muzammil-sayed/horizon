variable "aws_account_short_name" {}

variable "region" {}

variable "sla" {}

variable "ec2_key_name" {}

# { default = "data-brewprod" }

variable "component" { default = "elasticsearch" }

variable "env" { default = "databrewprod" }

variable "jive_service" { default = "cloudsearch" }

variable "jive_service_short_name" { default = "search" }

variable "route53_zone_id" { description = "Global private DNS zone" }

variable "route53_data_zone_id" { default = "Z3QR57QN1EXLU9" }

variable "route53_databrewprod_zone_id" { default = "Z3NUPZYDNEE69L" }

variable "instance_size" { default = "r4.large" }

variable "ebs_volume_size" { default = "200" }

variable "ami_id" { default = "ami-d2c924b2" }

variable "uswesta_vpc_subnet_id" { default = "subnet-3b59924d" }

variable "uswestb_vpc_subnet_id" { default = "subnet-1fd4657b" }

variable "uswestc_vpc_subnet_id" { default = "subnet-897b61d0" }
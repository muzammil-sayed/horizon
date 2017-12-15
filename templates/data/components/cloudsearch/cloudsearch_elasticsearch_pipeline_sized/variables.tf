variable "aws_account_short_name" {}

variable "region" {}

variable "sla" {}

variable "env" {}

variable "jive_service" { default = "cloudsearch" }

variable "jive_service_short_name" { default = "search" }

variable "route53_zone_id" { description = "Global private DNS zone" }

variable "route53_data_zone_id" { default = "Z18Q9DET05Y2Z8" }

variable "component" { default = "elasticsearch" }

variable "env" { default = "integ" }

variable "route53_data_zone_id" { default = "Z3QR57QN1EXLU9" }

variable "instance_size" { default = "r4.large" }

variable "ebs_volume_size" { default = "200" }

variable "ami_id" { default = "ami-d2c924b2" }

variable "route53_datainteg_zone_id" { default = "Z3NUPZYDNEE69L" }  #  Need to add this

variable "uswesta_vpc_subnet_id" { default = "subnet-3b59924d" }  # Update these

variable "uswestb_vpc_subnet_id" { default = "subnet-1fd4657b" }

variable "uswestc_vpc_subnet_id" { default = "subnet-897b61d0" }
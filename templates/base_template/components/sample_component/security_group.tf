resource "aws_security_group" "sample_security_group" {
    name = "${var.env}-security_group"
    description = "Access to Things"
    vpc_id = "${var.aws_vpc_main}"
    ingress {
      from_port = 443
      to_port = 443
      protocol = "6"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name                    = "${var.env}-security_group"
        pipeline_phase          = "${var.env}"
        region                  = "${var.region}"
        jive_service            = "${var.region}_${var.aws_account_short_name}"
        service_component       = "sample"
    }
}


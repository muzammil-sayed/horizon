resource "aws_security_group" "dbaas" {
	name 		= "${var.region}-${var.sla}-${var.jive_service}"
	description = "DBaaS DB access"
	vpc_id		= "${var.aws_vpc_main}"

	ingress {
	  from_port		= 5432
	  to_port		= 5432
	  protocol		= "tcp"
	  cidr_blocks	= ["10.0.0.0/8"]
	}

	tags {
	  Name 				= "${var.region}-${var.sla}-${var.jive_service}"
	  pipeline_phase    = "${var.env}"
      jive_service      = "${var.jive_service}"
      service_component = "${var.jive_service}"
      region            = "${var.region}"
      sla               = "${var.sla}"
      account_name      = "${var.aws_account_short_name}"
	}
}
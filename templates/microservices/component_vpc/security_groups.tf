data "aws_security_group" "bastion" {
  filter {
    name   = "tag:jive_service"
    values = ["infrastructure"]
  }
}

resource "aws_security_group" "env_instance" {
  name        = "${var.env}-instance"
  description = "All instances within the evironment"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    security_groups = ["${data.aws_security_group.bastion.id}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${data.aws_security_group.bastion.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name           = "${var.env}-instance"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_security_group" "jcx-rds" {
  name        = "${var.env}-rds"
  description = "RDS DB access for JCX."
  vpc_id      = "${var.aws_vpc_main}"
  count       = "${var.condition["jcx_vpc"]}"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = ["${var.cidr["vpc"]}"]
  }

  tags {
    Name              = "${var.env}-${var.jcx_rds_db_name}"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
    service_component = "${var.jive_service}-rds"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
  }
}

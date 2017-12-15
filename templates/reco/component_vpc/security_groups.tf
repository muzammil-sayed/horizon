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
    from_port       = 8
    to_port         = 0
    protocol        = "icmp"
    security_groups = ["${data.aws_security_group.bastion.id}"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${data.aws_security_group.bastion.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    name           = "${var.env}-instance"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_security_group" "natgw_instance" {
  name        = "${var.env}-natgw-instance"
  description = "Members of this SG are allowed to send any type of traffic to the NAT Box."
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.env_instance.id}"]
  }

  tags {
    name           = "${var.env}-natgw-instance"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_security_group" "admin_instance" {
  name        = "${var.env}-admin-instance"
  description = "Admin instances for the VPC"
  vpc_id      = "${aws_vpc.main.id}"

  tags {
    name           = "${var.env}-admin-instance"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

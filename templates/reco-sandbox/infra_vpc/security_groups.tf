resource "aws_security_group" "jive_phx_dc" {
  name        = "${var.env}-jive-phx-dc"
  description = "Allow SSH and Ping from CIDRs within Jive PHX Data Center"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name           = "${var.env}-jive-phx-dc"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
    jive_service   = "infrastructure"
  }
}

resource "aws_security_group" "env_instance" {
  name        = "${var.env}-instance"
  description = "Empty SG for all instances within the environment"
  vpc_id      = "${aws_vpc.main.id}"

  tags {
    Name           = "${var.env}-instance"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

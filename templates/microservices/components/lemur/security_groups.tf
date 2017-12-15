resource "aws_security_group" "lemur_instance" {
  name   = "${var.env}-lemur-instance"
  description = "Access to Lemur instance"
  vpc_id = "${var.aws_vpc_main}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
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
    Name              = "${var.env}-lemur-instance"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
    service_component = "${var.jive_service}"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
  }
}

resource "aws_security_group" "lemur_db" {
  name   = "${var.env}-lemur-db"
  description = "Access to Lemur DB"
  vpc_id = "${var.aws_vpc_main}"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${aws_security_group.lemur_instance.id}"]
  }

  tags {
    Name              = "${var.env}-lemur-db"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
    service_component = "${var.jive_service}"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
  }
}

resource "aws_security_group" "conversation_connector" {
  name        = "${var.env}-conversation_connector"
  description = "Access to conversation connectors (${var.env})"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 55001
    to_port     = 55001
    protocol    = "tcp"
    cidr_blocks = ["${var.conversation_ingress_cidr_blocks}"]
  }

  tags {
    Name              = "${var.env}-conversation_connector"
    Pipeline_Phase    = "${var.env}"
    Jive_Service      = "${var.jive_service}"
    Service_Component = "connector"
  }
}

resource "aws_security_group" "conversation_connectors_elb" {
  name        = "${var.env}-conversation_connectors-elb"
  description = "Access to conversation connectors elb (${var.env})"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name              = "${var.env}-conversation_connectors_elb"
    Pipeline_Phase    = "${var.env}"
    Jive_Service      = "${var.jive_service}"
    Service_Component = "connectors"
  }
}

resource "aws_security_group" "conversation_postgres" {
  name        = "${var.env}-conversation_postgres"
  description = "Access to conversation postgres (${var.env})"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${var.conversation_ingress_cidr_blocks}"]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion_cidr}"]
  }

  tags {
    Name              = "${var.env}-conversation_postgres"
    Pipeline_Phase    = "${var.env}"
    Jive_Service      = "${var.jive_service}"
  }
}

resource "aws_security_group" "conversation_redis" {
  name        = "${var.env}-conversation_redis"
  description = "Access to conversation redis (${var.env})"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["${var.conversation_ingress_cidr_blocks}"]
  }

  tags {
    Name              = "${var.env}-conversation_redis"
    Pipeline_Phase    = "${var.env}"
    Jive_Service      = "${var.jive_service}"
  }
}

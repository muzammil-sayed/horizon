resource "aws_security_group" "identity_default_postgres" {
  name        = "${var.env}-identity_default_postgres"
  description = "Access to identity default postgres (${var.env})"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${var.identity_ingress_cidr_blocks}"]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion_cidr}"]
  }

  tags {
    Name              = "${var.env}-identity_default_postgres"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
  }
}

resource "aws_security_group" "identity_migration_postgres" {
  name        = "${var.env}-identity_migration_postgres"
  description = "Access to identity migration postgres (${var.env})"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${var.identity_ingress_cidr_blocks}"]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion_cidr}"]
  }

  tags {
    Name              = "${var.env}-identity_migration_postgres"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
  }
}

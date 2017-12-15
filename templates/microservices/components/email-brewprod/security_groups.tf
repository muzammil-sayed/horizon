resource "aws_security_group" "postgres" {
  name        = "brew-${var.mako_env}-postgres-email"
  description = "Postgres DB access."
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/0"]
  }

  tags {
    Name              = "brew-${var.mako_env}-${var.postgres_db_name}"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
    service_component = "${var.jive_service}-postgres-email"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
  }
}

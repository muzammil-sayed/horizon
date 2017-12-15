resource "aws_security_group" "aurora" {
  name        = "${var.jive_service}-aurora"
  description = "Aurora DB access."
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/0"]
  }

  tags {
    Name              = "${var.mako_env}-${var.aurora_db_name}"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
    service_component = "${var.jive_service}-aurora"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
  }
}

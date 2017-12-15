resource "aws_security_group" "upena_api_sg" {
  name        = "${var.region}-${var.aws_account_short_name}-upena-api"
  description = "Allows necessary communication between upena-api instances"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 1175
    to_port     = 1175
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10000
    to_port     = 11000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name              = "${var.region}-${var.aws_account_short_name}-upena-api"
    Pipeline_phase    = "${var.env}"
    Jive_service      = "${var.jive_service}"
    Service_component = "upena-api"
    Region            = "${var.region}"
    SLA               = "${var.sla}"
    Account_name      = "${var.aws_account_short_name}"
  }
}

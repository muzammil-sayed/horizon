resource "aws_db_parameter_group" "default" {
    name = "${var.postgres_parameter_group}"
    family = "postgres9.5"
    }



resource "aws_db_instance" "pg-email" {
  allocated_storage    = 5
  engine               = "postgres"
  engine_version       = "9.5.2"
  instance_class       = "${var.postgres_instance_type}"
  name                 = "${var.postgres_db_name}"
  username             = "${var.postgres_username}"
  password             = "${var.postgres_password}"
  db_subnet_group_name = "${aws_db_subnet_group.postgres.name}"
  parameter_group_name = "${var.postgres_parameter_group}"
  identifier           = "${var.postgres_instance_identifier}"
  vpc_security_group_ids = ["${aws_security_group.postgres.id}"]
}

resource "aws_db_subnet_group" "postgres" {
  name        = "soa-pg-${var.postgres_subnet_name}-${var.mako_env}-group"
  subnet_ids  = ["${lookup(var.aws_subnet_natdc, "key0")}", "${lookup(var.aws_subnet_natdc, "key1")}", "${lookup(var.aws_subnet_natdc, "key2")}"]
  description = "Managed by Horizon"

  tags {
    Name              = "${var.env}-${var.postgres_subnet_name}"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
    service_component = "${var.jive_service}-postgres"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
  }
}

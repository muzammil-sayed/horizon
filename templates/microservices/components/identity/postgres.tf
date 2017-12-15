resource "aws_db_parameter_group" "identity_default" {
  name = "soa-${var.jive_service}-postgres-${var.env}-param"
  family = "postgres9.5"
  description = "Managed by Horizon"
}

resource "aws_db_parameter_group" "identity_migration" {
  name = "soa-${var.jive_service}-migration-postgres-${var.env}-param"
  family = "postgres9.5"
  description = "Managed by Horizon"
}

resource "aws_db_instance" "identity_default" {
  allocated_storage    = "${var.identity_default_pg_alocated_storage}"
  storage_type         = "gp2"
  multi_az             = "True"
  engine               = "postgres"
  engine_version       = "9.5.2"
  instance_class       = "${var.identity_postgres_instance_type}"
  name                 = "${var.identity_postgres_db_name}"
  username             = "${var.identity_postgres_username}"
  password             = "${var.identity_postgres_password}"
  db_subnet_group_name = "${var.default_rds_subnet_group}"
  parameter_group_name = "${aws_db_parameter_group.identity_default.name}"
  identifier           = "${var.identity_default_postgres_instance_identifier}"
  vpc_security_group_ids = ["${aws_security_group.identity_default_postgres.id}"]
  storage_encrypted      = "True"
}

resource "aws_db_instance" "identity_migration" {
  allocated_storage    = "${var.identity_migration_pg_alocated_storage}"
  storage_type         = "gp2"
  multi_az             = "True"
  engine               = "postgres"
  engine_version       = "9.5.2"
  instance_class       = "${var.identity_postgres_instance_type}"
  name                 = "${var.identity_postgres_db_name}"
  username             = "${var.identity_postgres_username}"
  password             = "${var.identity_postgres_password}"
  db_subnet_group_name = "${var.default_rds_subnet_group}"
  parameter_group_name = "${aws_db_parameter_group.identity_migration.name}"
  identifier           = "${var.identity_migration_postgres_instance_identifier}"
  vpc_security_group_ids = ["${aws_security_group.identity_migration_postgres.id}"]
  storage_encrypted      = "True"
}


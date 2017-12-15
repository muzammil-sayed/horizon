resource "aws_db_parameter_group" "conversation_postgres" {
  name = "gc-${var.jive_service}-postgres-${var.env}-param"
  family = "postgres9.6"
  description = "Managed by Horizon"
}


resource "aws_db_instance" "conversation_postgres" {
  allocated_storage    = "${var.conversation_postgres_allocated_storage}"
  storage_type         = "gp2"
  multi_az             = "True"
  engine               = "postgres"
  engine_version       = "9.6.2"
  instance_class       = "${var.conversation_postgres_instance_type}"
  name                 = "${var.conversation_postgres_db_name}"
  username             = "${var.conversation_postgres_username}"
  password             = "${var.conversation_postgres_password}"
  db_subnet_group_name = "${var.default_rds_subnet_group}"
  parameter_group_name = "${aws_db_parameter_group.conversation_postgres.name}"
  identifier           = "${var.conversation_postgres_instance_identifier}"
  vpc_security_group_ids = ["${aws_security_group.conversation_postgres.id}"]
  storage_encrypted      = "True"
}

resource "aws_db_parameter_group" "fileservice_mysql" {
  name = "ng-${var.jive_service}-mysql-${var.env}-param"
  family = "mysql5.7"
  description = "Managed by Horizon"
}


resource "aws_db_instance" "fileservice_mysql" {
  allocated_storage    = "${var.fileservice_mysql_allocated_storage}"
  storage_type         = "gp2"
  multi_az             = "True"
  engine               = "mysql"
  engine_version       = "5.7.17"
  instance_class       = "${var.fileservice_mysql_instance_type}"
  name                 = "${var.fileservice_mysql_db_name}"
  username             = "${var.fileservice_mysql_username}"
  password             = "${var.fileservice_mysql_password}"
  db_subnet_group_name = "${var.default_rds_subnet_group}"
  parameter_group_name = "${aws_db_parameter_group.fileservice_mysql.name}"
  identifier           = "${var.fileservice_mysql_instance_identifier}"
  vpc_security_group_ids = ["${aws_security_group.fileservice_mysql.id}"]
  storage_encrypted      = "True"
}

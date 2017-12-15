resource "aws_db_instance" "lemurdb" {
  identifier             = "lemurdb"
  engine                 = "postgres"
  engine_version         = "9.4.7"
  port                   = 5432
  publicly_accessible    = false
  multi_az               = true
  storage_encrypted      = true
  allocated_storage      = "${var.lemur_db_volume_size}"
  iops                   = "${var.lemur_db_iops}"
  instance_class         = "${var.lemur_db_instance_type}"
  username               = "${var.lemur_db_username}"
  password               = "${var.lemur_db_password}"
  vpc_security_group_ids = ["${aws_security_group.lemur_db.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.lemur_db_subnet.name}"

  backup_window           = "05:00-08:30"
  backup_retention_period = 30
  maintenance_window      = "Sat:09:30-Sat:22:00"

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

data "aws_subnet_ids" "natdc_subnet_ids" {
  vpc_id = "${var.aws_vpc_main}"

  tags {
    "kubernetes.io/role/internal-elb" = "us-east-1_jivek8-aws"
  }
}

resource "aws_db_subnet_group" "lemur_db_subnet" {
  name        = "${var.env}-lemur-db-subnet"
  description = "Lemur DB Subnet Group Managed by Horizon"
  subnet_ids  = ["${data.aws_subnet_ids.natdc_subnet_ids.ids}"]

  tags {
    Name              = "${var.env}-lemur-db-subnet"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
    service_component = "${var.jive_service}"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
  }
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  identifier           = "soa-${var.aurora_db_name}-${var.mako_env}-db${count.index}"
  cluster_identifier   = "${aws_rds_cluster.aurora_cluster.id}"
  instance_class       = "${var.aurora_instance_type}"
  db_subnet_group_name = "${aws_db_subnet_group.aurora.name}"
  count                = "${var.az_count}"

  tags {
    Name              = "${var.env}-${var.aurora_db_name}"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
    service_component = "${var.jive_service}-aurora"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
  }
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier     = "soa-${var.aurora_db_name}-${var.mako_env}-db-cluster"
  db_subnet_group_name   = "${aws_db_subnet_group.aurora.name}"
  database_name          = "${var.env}${var.aurora_db_name}"
  master_username        = "${var.aurora_username}"
  master_password        = "${var.aurora_password}"
  vpc_security_group_ids = ["${aws_security_group.aurora.id}"]
  storage_encrypted      = true
}

resource "aws_db_subnet_group" "aurora" {
  name        = "soa-${var.aurora_db_name}-${var.mako_env}-group"
  subnet_ids  = ["${lookup(var.aws_subnet_natdc, "key0")}", "${lookup(var.aws_subnet_natdc, "key1")}", "${lookup(var.aws_subnet_natdc, "key2")}"]
  description = "Managed by Horizon"

  tags {
    Name              = "${var.env}-${var.aurora_db_name}"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
    service_component = "${var.jive_service}-aurora"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
  }
}

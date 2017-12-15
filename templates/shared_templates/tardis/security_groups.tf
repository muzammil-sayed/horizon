data "aws_security_group" "k8s_etcd_instance" {
  filter {
    name   = "tag:Name"
    values = ["${null_resource.k8s_cluster.triggers.name}-etcd-instance"]
  }
}

data "aws_security_group" "k8s_worker_instance" {
  filter {
    name   = "tag:Name"
    values = ["${null_resource.k8s_cluster.triggers.name}-worker-instance"]
  }
}

data "aws_security_group" "k8s_master_instance" {
  filter {
    name   = "tag:Name"
    values = ["${null_resource.k8s_cluster.triggers.name}-master-instance"]
  }
}

resource "aws_security_group" "tardis_instance" {
  name        = "${null_resource.k8s_cluster.triggers.name}-tardis-instance"
  description = "Access to tardis nodes"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    self        = true
  }

  ingress {
    from_port       = "8472"
    to_port         = "8472"
    protocol        = "udp"
    security_groups = ["${data.aws_security_group.k8s_worker_instance.id}", "${data.aws_security_group.k8s_master_instance.id}"]
  }

  tags {
    Name              = "${null_resource.k8s_cluster.triggers.name}-tardis-instance"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
    service_component = "tardis"
    region            = "${var.region}"
    sla               = "${var.sla}"
  }
}

resource "aws_security_group_rule" "k8s_etcd_instance" {
  type                     = "ingress"
  from_port                = "2379"
  to_port                  = "2380"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.tardis_instance.id}"
  security_group_id        = "${data.aws_security_group.k8s_etcd_instance.id}"
}

resource "aws_security_group_rule" "k8s_worker_instance" {
  type                     = "ingress"
  from_port                = "8472"
  to_port                  = "8472"
  protocol                 = "udp"
  source_security_group_id = "${aws_security_group.tardis_instance.id}"
  security_group_id        = "${data.aws_security_group.k8s_worker_instance.id}"
}

resource "aws_security_group_rule" "k8s_master_instance" {
  type                     = "ingress"
  from_port                = "8472"
  to_port                  = "8472"
  protocol                 = "udp"
  source_security_group_id = "${aws_security_group.tardis_instance.id}"
  security_group_id        = "${data.aws_security_group.k8s_master_instance.id}"
}

resource "aws_security_group" "k8s_master_instance" {
  name        = "${null_resource.k8s_cluster.triggers.name}-master-instance"
  description = "Access to K8S Master nodes"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    self        = true
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    self        = true
  }

  # Kubernetes adds ingress rules and we don't want to remove them on Terraform apply
  lifecycle {
    ignore_changes = ["ingress"]
  }

  tags {
    Name               = "${null_resource.k8s_cluster.triggers.name}-master-instance"
    Pipeline_phase     = "${var.env}"
    Jive_service       = "${var.jive_service}"
    Service_component  = "k8s-master"
    Region             = "${var.region}"
    SLA                = "${var.sla}"
  }
}

# Adding SG rule to k8s master separately from SG creation to circumvent a cycle graph
resource "aws_security_group_rule" "k8s_master_instance" {
    type                     = "ingress"
    from_port                = 0
    to_port                  = 0
    protocol                 = -1
    source_security_group_id = "${aws_security_group.k8s_worker_instance.id}"
    security_group_id        = "${aws_security_group.k8s_master_instance.id}"
}

resource "aws_security_group" "k8s_worker_instance" {
  name        = "${null_resource.k8s_cluster.triggers.name}-worker-instance"
  description = "Allow traffic to K8S worker nodes"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.k8s_master_instance.id}"]
    self            = true
  }

  # Kubernetes adds ingress rules and we don't want to remove them on Terraform apply
  lifecycle {
    ignore_changes = ["ingress"]
  }

  tags {
    Name               = "${null_resource.k8s_cluster.triggers.name}-worker-instance"
    Pipeline_phase     = "${var.env}"
    Jive_service       = "${var.jive_service}"
    Service_component  = "k8s-worker"
    Region             = "${var.region}"
    SLA                = "${var.sla}"
    KubernetesCluster  = "${null_resource.k8s_cluster.triggers.name}"
  }
}

# Adding SG rule to k8s master separately from SG creation to circumvent a cycle graph
resource "aws_security_group_rule" "k8s_worker_instance" {
    type                     = "ingress"
    from_port                = 30000
    to_port                  = 32767
    protocol                 = "tcp"
    cidr_blocks              = ["10.0.0.0/8"]
    security_group_id        = "${aws_security_group.k8s_worker_instance.id}"
}

resource "aws_security_group" "k8s_etcd_instance" {
  name        = "${null_resource.k8s_cluster.triggers.name}-kubernetes-etcd-instance"
  description = "Access to K8S etcd nodes"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port       = 2379
    to_port         = 2379
    protocol        = "tcp"
    security_groups = ["${aws_security_group.k8s_master_instance.id}", "${aws_security_group.k8s_worker_instance.id}"]
    self            = true
  }

  ingress {
    from_port       = 2380
    to_port         = 2380
    protocol        = "tcp"
    security_groups = ["${aws_security_group.k8s_master_instance.id}", "${aws_security_group.k8s_worker_instance.id}"]
    self            = true
  }

  tags {
    Name               = "${null_resource.k8s_cluster.triggers.name}-etcd-instance"
    Pipeline_phase     = "${var.env}"
    Jive_service       = "${var.jive_service}"
    Service_component  = "k8s-etcd"
    Region             = "${var.region}"
    SLA                = "${var.sla}"
  }
}

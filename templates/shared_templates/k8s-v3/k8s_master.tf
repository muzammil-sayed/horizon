resource "aws_network_interface" "k8s_master" {
  subnet_id         = "${lookup(var.aws_subnet_natdc, "key${count.index}")}"
  source_dest_check = true
  security_groups   = ["${var.aws_security_group_env_instance}", "${aws_security_group.k8s_master_instance.id}"]
  count             = "${var.k8s_master_instance_count}"
  private_ips       = ["${cidrhost(var.cidr.natdc-subnet-1, 10)}"]

  tags {
    Name              = "${var.env}-k8s-master-instance${count.index+1}"
    Hostname          = "${null_resource.k8s_cluster.triggers.name}-master${count.index+1}"
    Pipeline_phase    = "${var.env}"
    Jive_service      = "${null_resource.k8s_cluster.triggers.name}"
    Service_component = "k8s-master"
    Region            = "${var.region}"
    SLA               = "${var.sla}"
    KubernetesCluster = "${null_resource.k8s_cluster.triggers.name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "k8s_master_eip" {
  vpc               = true
  network_interface = "${element(aws_network_interface.k8s_master.*.id, count.index)}"
  count             = "${var.k8s_master_instance_count}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "k8s_master" {
  image_id                    = "${var.k8s_ami}"
  instance_type               = "${var.k8s_master_instance_type}"
  key_name                    = "${var.k8s_master_keypair}"
  iam_instance_profile        = "${aws_iam_instance_profile.k8s-master.id}"
  security_groups             = ["${var.aws_security_group_env_instance}", "${aws_security_group.k8s_master_instance.id}"]
  associate_public_ip_address = false

  root_block_device = {
    volume_type = "gp2"
    volume_size = "${var.k8s_master_instance_volume_size}"
  }

  lifecycle {
    create_before_destroy = true
  }

  user_data = "${template_file.cloud_config.rendered}"
}

resource "aws_autoscaling_group" "k8s_master" {
  name                 = "${var.env}-k8s-master-asg${count.index+1}"
  max_size             = "${var.k8s_master_asg_max}"
  min_size             = "${var.k8s_master_asg_min}"
  vpc_zone_identifier  = ["${lookup(var.aws_subnet_natdc, "key${count.index}")}"]
  launch_configuration = "${aws_launch_configuration.k8s_master.id}"
  count                = "${var.k8s_master_instance_count}"

  tag {
    key                 = "Name"
    value               = "${var.env}-k8s-master-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Hostname"
    value               = "${null_resource.k8s_cluster.triggers.name}-master${count.index+1}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Pipeline_phase"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Jive_service"
    value               = "${null_resource.k8s_cluster.triggers.name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Service_component"
    value               = "k8s-master"
    propagate_at_launch = true
  }

  tag {
    key                 = "Region"
    value               = "${var.region}"
    propagate_at_launch = true
  }

  tag {
    key                 = "SLA"
    value               = "${var.sla}"
    propagate_at_launch = true
  }

  tag {
    key                 = "KubernetesCluster"
    value               = "${null_resource.k8s_cluster.triggers.name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "K8s_cluster"
    value               = "${null_resource.k8s_cluster.triggers.name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Master_ip"
    value               = "${element(aws_eip.k8s_master_eip.*.private_ip, count.index)}"
    propagate_at_launch = true
  }
}

resource "aws_ebs_volume" "k8s_master" {
  availability_zone = "${var.region}${lookup(var.az, "az${count.index+1}")}"
  encrypted         = true
  size              = "${var.k8s_master_instance_volume_size}"
  type              = "gp2"
  count             = "${var.k8s_master_instance_count}"

  tags {
    Name              = "${var.env}-k8s_master-instance"
    Hostname          = "${null_resource.k8s_cluster.triggers.name}-master${count.index+1}"
    Pipeline_phase    = "${var.env}"
    Jive_service      = "infrastructure"
    Region            = "${var.region}"
    SLA               = "${var.sla}"
    Service_component = "k8s-master"
  }
}

resource "aws_route53_record" "k8s_master" {
  zone_id = "${var.route53_zone_id}"
  name    = "kubernetes-${replace(null_resource.k8s_cluster.triggers.name, "_", "-")}"
  type    = "A"
  ttl     = "60"
  records = ["${aws_network_interface.k8s_master.private_ips}"]
}

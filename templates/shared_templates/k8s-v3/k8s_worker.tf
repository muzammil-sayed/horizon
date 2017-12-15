resource "aws_launch_configuration" "k8s_worker" {
  image_id                    = "${var.k8s_ami}"
  instance_type               = "${var.k8s_worker_instance_type}"
  key_name                    = "${var.k8s_worker_keypair}"
  iam_instance_profile        = "${aws_iam_instance_profile.k8s-node.id}"
  security_groups             = ["${var.aws_security_group_env_instance}", "${aws_security_group.k8s_worker_instance.id}"]
  associate_public_ip_address = false

  root_block_device = {
    volume_type = "gp2"
    volume_size = "${var.k8s_worker_instance_volume_size}"
  }

  lifecycle {
    create_before_destroy = true
  }

  user_data = "${template_file.cloud_config.rendered}"
}

resource "aws_autoscaling_group" "k8s_worker_asg" {
  name                 = "${var.env}-k8s-worker-asg${count.index+1}"
  max_size             = "${var.k8s_worker_asg_max}"
  min_size             = "${var.k8s_worker_asg_min}"
  vpc_zone_identifier  = ["${lookup(var.aws_subnet_natdc, "key${count.index}")}"]
  launch_configuration = "${aws_launch_configuration.k8s_worker.id}"
  count                = "${var.k8s_worker_instance_count}"

  tag {
    key                 = "Name"
    value               = "${var.env}-k8s-worker-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Hostname"
    value               = "k8s-node${count.index+1}"
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
    value               = "k8s-node"
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
    value               = "${element(aws_eip.k8s_master_eip.*.private_ip, var.k8s_master_instance_count.index)}"
    propagate_at_launch = true
  }
}

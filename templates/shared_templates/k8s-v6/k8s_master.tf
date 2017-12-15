resource "aws_eip" "k8s_master_eip" {
  vpc   = true
  count = "${var.k8s_master_instance_count}"

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

  user_data = "${data.template_file.cloud_config.rendered}"
}

resource "aws_autoscaling_group" "k8s_master" {
  name                 = "${var.env}-k8s-master-asg${count.index+1}"
  max_size             = "${var.k8s_master_asg_max}"
  min_size             = "${var.k8s_master_asg_min}"
  vpc_zone_identifier  = ["${lookup(var.aws_subnet_natdc, "key${count.index}")}"]
  launch_configuration = "${aws_launch_configuration.k8s_master.id}"
  load_balancers       = ["${aws_elb.k8s_master.id}"]
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
    Jive_service      = "${null_resource.k8s_cluster.triggers.name}"
    Region            = "${var.region}"
    SLA               = "${var.sla}"
    Service_component = "k8s-master"
  }
}

resource "aws_elb" "k8s_master" {
  name            = "${var.env}-k8s-master-elb"
  security_groups = ["${var.aws_security_group_env_instance}", "${aws_security_group.k8s_master_instance.id}"]
  subnets         = ["${lookup(var.aws_subnet_natdc, "key${count.index}")}"]
  internal        = true

  # set idle_timeout to 30 min, to match F5 settings - this will help with
  # long-lived watches from MAKO, and when viewing output from
  # `kubectl logs <pod> -f`
  idle_timeout = 1800

  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:443"
    interval            = 30
  }

  tags {
    Name              = "${var.env}-k8s_master-elb"
    Hostname          = "${null_resource.k8s_cluster.triggers.name}-master${count.index+1}"
    Pipeline_phase    = "${var.env}"
    Jive_service      = "${null_resource.k8s_cluster.triggers.name}"
    Region            = "${var.region}"
    SLA               = "${var.sla}"
    Service_component = "k8s-master"
  }
}

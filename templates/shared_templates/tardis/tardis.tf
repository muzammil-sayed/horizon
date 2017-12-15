# Data sources to populate list of natdc subnets
data "aws_availability_zones" "available" {}

data "aws_subnet" "natdc" {
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  vpc_id            = "${var.aws_vpc_main}"
  state             = "available"
  count = "${var.tardis_instance_count}"

  tags {
    "Name" = "${var.env}-natdc-subnet"
  }
}

resource "aws_eip" "tardis_eip" {
  vpc               = true
  count             = "${var.tardis_instance_count}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "tardis" {
  image_id                    = "${var.k8s_ami}"
  instance_type               = "${var.tardis_instance_type}"
  key_name                    = "${var.tardis_keypair}"
  iam_instance_profile        = "${aws_iam_instance_profile.tardis.id}"
  security_groups             = ["${var.aws_security_group_env_instance}", "${aws_security_group.tardis_instance.id}"]
  associate_public_ip_address = false

  root_block_device = {
    volume_type = "gp2"
    volume_size = "${var.tardis_instance_volume_size}"
  }

  lifecycle {
    create_before_destroy = true
  }

  user_data = "${data.template_file.cloud_config.rendered}"
}

resource "aws_autoscaling_group" "tardis_asg" {
  name                 = "${var.env}-tardis-asg${count.index+1}"
  max_size             = "${var.tardis_asg_max}"
  min_size             = "${var.tardis_asg_min}"
  vpc_zone_identifier  = ["${element(data.aws_subnet.natdc.*.id, count.index)}"]
  launch_configuration = "${aws_launch_configuration.tardis.id}"
  load_balancers       = ["${aws_elb.tardis.id}"]
  count                = "${var.tardis_instance_count}"

  tag {
    key                 = "Name"
    value               = "${var.env}-tardis-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Hostname"
    value               = "${null_resource.k8s_cluster.triggers.name}-tardis${count.index+1}"
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
    value               = "tardis"
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

resource "aws_elb" "tardis" {
  name            = "${var.env}-tardis-elb"
  security_groups = ["${var.aws_security_group_env_instance}", "${aws_security_group.tardis_instance.id}"]
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
    Name              = "${var.env}-tardis-elb"
    Hostname          = "${null_resource.k8s_cluster.triggers.name}-tardis${count.index+1}"
    Pipeline_phase    = "${var.env}"
    Jive_service      = "${null_resource.k8s_cluster.triggers.name}"
    Region            = "${var.region}"
    SLA               = "${var.sla}"
    Service_component = "tardis"
  }
}

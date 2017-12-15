resource "aws_launch_configuration" "lemur_node" {
  image_id             = "${var.lemur_ami}"
  instance_type        = "${var.lemur_instance_type}"
  key_name             = "${var.lemur_keypair}"
  iam_instance_profile = "${aws_iam_instance_profile.lemur_profile.id}"
  security_groups      = ["${aws_security_group.lemur_instance.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.lemur_instance_root_volume_size}"
  }

  lifecycle {
    create_before_destroy = true
  }

  user_data = "${data.template_file.cloud_config.rendered}"
}

resource "aws_autoscaling_group" "lemur_asg" {
  name                      = "${var.env}-lemur-asg${count.index+1}"
  min_size                  = "${var.lemur_asg_min}"
  max_size                  = "${var.lemur_asg_max}"
  vpc_zone_identifier       = ["subnet-897fb5d3"]
  health_check_type         = "EC2"
  health_check_grace_period = 30
  launch_configuration      = "${aws_launch_configuration.lemur_node.name}"
  load_balancers            = ["${aws_elb.lemur.name}"]
  count                     = "${var.lemur_instance_count}"

  tag {
    key                 = "Name"
    value               = "${var.env}-lemur-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Hostname"
    value               = "${var.env}-lemur-instance${count.index+1}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Pipeline_phase"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Jive_service"
    value               = "${var.jive_service}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Service_component"
    value               = "${var.jive_service}"
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
    key                 = "Account_name"
    value               = "${var.aws_account_short_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "KubernetesCluster"
    value               = ""
    propagate_at_launch = true
  }
}

resource "aws_ebs_volume" "lemur_ebs" {
  availability_zone = "us-east-1a"
  size              = "${var.lemur_instance_volume_size}"
  type              = "gp2"
  encrypted         = true
  count             = "${var.lemur_instance_count}"

  tags {
    Name              = "${var.env}-lemur-instance"
    Hostname          = "${var.env}-lemur-instance${count.index+1}"
    Pipeline_phase    = "${var.env}"
    Jive_service      = "${var.jive_service}"
    Service_component = "${var.jive_service}"
    Region            = "${var.region}"
    SLA               = "${var.sla}"
    Account_name      = "${var.aws_account_short_name}"
  }
}

resource "aws_elb" "lemur" {
  name            = "lemur-elb"
  security_groups = ["${aws_security_group.lemur_instance.id}"]

  #subnets         = ["subnet-897fb5d3"] # private
  subnets  = ["subnet-307fb56a"] # public
  internal = false

  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
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
    Name              = "${var.env}-lemur-elb"
    Pipeline_phase    = "${var.env}"
    Jive_service      = "${var.jive_service}"
    Service_component = "${var.jive_service}"
    Region            = "${var.region}"
    SLA               = "${var.sla}"
    Account_name      = "${var.aws_account_short_name}"
  }
}

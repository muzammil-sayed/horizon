resource "aws_security_group_rule" "nginx_port_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.nginx_ports.id}"
}

resource "aws_security_group_rule" "nginx_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/8"]
  security_group_id = "${aws_security_group.nginx_ports.id}"
}

resource "aws_security_group" "nginx_ports" {
  name        = "${var.jive_subservice}_nginx_ports"
  description = "Allow traffic on port 443"
  vpc_id      = "${var.aws_vpc_main}"
}

data "template_file" "user_data" {
  # I know this says "elasticsearch", but it's all the same
  template = "${file("${path.module}/elasticsearch_user_data.sh")}"

  vars {
    region         = "${var.region}"
    pipeline_phase = "${var.env}"
    account_name   = "${var.aws_account_short_name}"
    bundle_name    = "${var.ansible_bundle_name}"
    bundle_version = "${var.ansible_bundle_version}"
    devices        = "${var.ebs_device}:${var.ebs_mountpoint}"

    # set this to anything to skip the EBS reattachment script (will still format)
    skip_ebs_reattach = "true"
  }
}

resource "aws_launch_configuration" "nginx_node" {
  name_prefix                 = "${var.jive_subservice_short_name}-nginx-es-node-"
  image_id                    = "${var.nginx_image_id}"
  instance_type               = "${var.nginx_instance_type}"
  key_name                    = "${var.ec2_key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.ebs-attach-and-secrets.name}"
  security_groups             = ["${var.aws_security_group_env_instance}", "${aws_security_group.nginx_ports.id}"]
  associate_public_ip_address = false
  ebs_optimized               = "${var.nginx_ebs_optimized}"

  lifecycle {
    create_before_destroy = true
  }

  user_data = "${data.template_file.user_data.rendered}"
}

resource "aws_autoscaling_group" "nginx_node_asg" {
  count = "${var.number_of_es_nginx_azs}"

  name                 = "${var.env}-${var.jive_subservice_short_name}-es-nginx-az${count.index + 1}-asg"
  max_size             = "${var.number_of_es_nginx_nodes_per_az}"
  min_size             = "${var.number_of_es_nginx_nodes_per_az}"
  vpc_zone_identifier  = ["${lookup(var.aws_subnet_natdc, "key${count.index}")}"]
  launch_configuration = "${aws_launch_configuration.nginx_node.id}"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.env}-${var.jive_subservice_short_name}-es-nginx"
    propagate_at_launch = true
  }

  tag {
    key                 = "make_dns"
    value               = "es-nginx.aws-${var.env}-${var.jive_subservice}"
    propagate_at_launch = true
  }

  tag {
    key                 = "pipeline_phase"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "service_component"
    value               = "es_nginx"
    propagate_at_launch = true
  }

  tag {
    key                 = "jive_service"
    value               = "${var.jive_service}"
    propagate_at_launch = true
  }

  tag {
    key                 = "jive_subservice"
    value               = "${var.jive_subservice}"
    propagate_at_launch = true
  }

  tag {
    key                 = "sla"
    value               = "${var.sla}"
    propagate_at_launch = true
  }
}

resource "aws_security_group_rule" "elasticsearch_port_9200" {
  type              = "ingress"
  from_port         = 9200
  to_port           = 9200
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.elasticsearch_ports.id}"
}

resource "aws_security_group_rule" "elasticsearch_port_9300" {
  type              = "ingress"
  from_port         = 9300
  to_port           = 9300
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.elasticsearch_ports.id}"
}

resource "aws_security_group_rule" "elasticsearch_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/8"]
  security_group_id = "${aws_security_group.elasticsearch_ports.id}"
}

resource "aws_security_group" "elasticsearch_ports" {
  name        = "${var.jive_subservice}_elasticsearch_ports"
  description = "Allow traffic on ye olde elasticsearch ports"
  vpc_id      = "${var.aws_vpc_main}"
}

data "template_file" "elasticsearch_user_data" {
  template = "${file("${path.module}/elasticsearch_user_data.sh")}"

  vars {
    region         = "${var.region}"
    pipeline_phase = "${var.env}"
    account_name   = "${var.aws_account_short_name}"
    bundle_name    = "${var.ansible_bundle_name}"
    bundle_version = "${var.ansible_bundle_version}"
    devices        = "${var.ebs_device}:${var.ebs_mountpoint}"

    # set this to anything to skip the EBS reattachment script (will still format)
    skip_ebs_reattach = ""
  }
}

resource "aws_launch_configuration" "elasticsearch_node" {
  name_prefix                 = "${var.jive_subservice_short_name}-elasticsearch-node-"
  image_id                    = "${var.elasticsearch_image_id}"
  instance_type               = "${var.elasticsearch_instance_type}"
  key_name                    = "${var.ec2_key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.ebs-attach-and-secrets.name}"
  security_groups             = ["${var.aws_security_group_env_instance}", "${aws_security_group.elasticsearch_ports.id}"]
  associate_public_ip_address = false
  ebs_optimized               = "${var.ebs_optimized}"

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20"
    delete_on_termination = false
  }

  ebs_block_device {
    device_name           = "${var.ebs_device}"
    volume_type           = "gp2"
    volume_size           = "${var.ebs_size}"
    delete_on_termination = false
    encrypted             = true
  }

  user_data = "${data.template_file.elasticsearch_user_data.rendered}"
}

resource "aws_launch_configuration" "elasticsearch_master" {
  name_prefix                 = "${var.jive_subservice_short_name}-elasticsearch-master-"
  image_id                    = "${var.elasticsearch_image_id}"
  instance_type               = "${var.es_master_instance_type}"
  key_name                    = "${var.ec2_key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.ebs-attach-and-secrets.name}"
  security_groups             = ["${var.aws_security_group_env_instance}", "${aws_security_group.elasticsearch_ports.id}"]
  associate_public_ip_address = false

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "30"
    delete_on_termination = false
  }

  user_data = "${data.template_file.elasticsearch_user_data.rendered}"
}

resource "aws_autoscaling_group" "elasticsearch_node_asg" {
  count = "${var.number_of_es_azs}"

  name     = "${var.env}-${var.jive_subservice_short_name}-es-node-az${count.index + 1}-asg"
  max_size = "${var.number_of_es_nodes_per_az}"
  min_size = "${var.number_of_es_nodes_per_az}"

  vpc_zone_identifier  = ["${lookup(var.aws_subnet_natdc, "key${count.index}")}"]
  launch_configuration = "${aws_launch_configuration.elasticsearch_node.id}"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.env}-${var.jive_subservice_short_name}-es-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "make_dns"
    value               = "node.aws-${var.env}-${var.jive_subservice}"
    propagate_at_launch = true
  }

  tag {
    key                 = "pipeline_phase"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "service_component"
    value               = "es_node"
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

resource "aws_autoscaling_group" "elasticsearch_master_asg" {
  count = "${var.number_of_es_master_azs}"

  name     = "${var.env}-${var.jive_subservice_short_name}-es-master-az${count.index + 1}-asg"
  max_size = "${var.number_of_es_master_nodes_per_az}"
  min_size = "${var.number_of_es_master_nodes_per_az}"

  vpc_zone_identifier  = ["${lookup(var.aws_subnet_natdc, "key${count.index}")}"]
  launch_configuration = "${aws_launch_configuration.elasticsearch_master.id}"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.env}-${var.jive_subservice_short_name}-es-master0${count.index + 1}"
    propagate_at_launch = true
  }

  tag {
    key                 = "make_dns"
    value               = "master.aws-${var.env}-${var.jive_subservice}"
    propagate_at_launch = true
  }

  tag {
    key                 = "pipeline_phase"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "service_component"
    value               = "es_master"
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

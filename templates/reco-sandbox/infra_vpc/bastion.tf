resource "aws_network_interface" "bastion" {
  subnet_id         = "${aws_subnet.natdc.0.id}"
  source_dest_check = true
  security_groups   = ["${aws_security_group.jive_phx_dc.id}"]
  private_ips       = ["${var.bastion_ip_addr}"]

  tags {
    Name              = "${var.env}-bastion-instance"
    pipeline_phase    = "${var.env}"
    service_component = "bastion"
    jive_service      = "infrastructure"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
  }
}

data "template_file" "bastion_user_data" {
  template = "${file("${path.module}/bastion_user_data.sh")}"

  vars {
    region         = "${var.region}"
    eni            = "${aws_network_interface.bastion.id}"
    bastion_ip     = "${var.bastion_ip_addr}"
    pipeline_phase = "${var.env}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_launch_configuration" "bastion" {
  image_id                    = "${var.bastion_ami}"
  instance_type               = "${var.bastion_instance_type}"
  key_name                    = "${var.bastion_keypair}"
  iam_instance_profile        = "${var.aws_iam_instance_profile_eni-attach}"
  security_groups             = ["${aws_security_group.jive_phx_dc.id}"]
  associate_public_ip_address = false

  root_block_device {
    delete_on_termination = true
    volume_size           = "${var.bastion_instance_volume_size}"
  }

  lifecycle {
    create_before_destroy = true
  }

  user_data = "${data.template_file.bastion_user_data.rendered}"
}

resource "aws_autoscaling_group" "bastion" {
  name                 = "${var.env}-bastion-asg-${aws_launch_configuration.bastion.name}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.natdc.0.id}"]
  launch_configuration = "${aws_launch_configuration.bastion.id}"

  tag {
    key                 = "Name"
    value               = "${var.env}-bastion-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "pipeline_phase"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "service_component"
    value               = "bastion"
    propagate_at_launch = true
  }

  tag {
    key                 = "jive_service"
    value               = "infrastructure"
    propagate_at_launch = true
  }

  tag {
    key                 = "region"
    value               = "${var.region}"
    propagate_at_launch = true
  }

  tag {
    key                 = "sla"
    value               = "${var.sla}"
    propagate_at_launch = true
  }

  tag {
    key                 = "account_name"
    value               = "${var.aws_account_short_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "bastionip"
    value               = "${var.bastion_ip_addr}"
    propagate_at_launch = true
  }
}

resource "aws_route53_record" "bastion" {
  zone_id = "${var.route53_zone_id}"
  name    = "bastion-${var.region}-${var.aws_account_short_name}"
  type    = "A"
  ttl     = "60"
  records = ["${var.bastion_ip_addr}"]
}

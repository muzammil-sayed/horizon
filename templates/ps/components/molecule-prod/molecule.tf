resource "aws_launch_configuration" "molecule_node" {
  image_id             = "${var.molecule_ami}"
  instance_type        = "${var.molecule_instance_type}"
  key_name             = "${var.molecule_keypair}"
  security_groups      = ["${var.aws_security_group_env_instance}", "${aws_security_group.molecule.id}"]
  iam_instance_profile = "${var.aws_iam_instance_profile_boomi-node}"

  root_block_device {
    volume_type = "gp2"
  }

  ebs_block_device = {
    device_name           = "/dev/sdf"
    volume_type           = "gp2"
    volume_size           = 100
    encrypted             = true
  }

  user_data = "${file("${path.module}/init-config.sh")}"

  lifecycle { create_before_destroy = true }
}

resource "aws_ebs_volume" "molecule" {
  availability_zone = "${var.region}${lookup(var.az, "az${count.index+1}")}"
  size              = "${var.molecule_volume_size}"
  type              = "gp2"
  encrypted         = true
  count             = "1"

  tags {
    pipeline_phase    = "${var.env}"
    region            = "${var.region}"
    account_name      = "${var.aws_account_short_name}"
    jive_service      = "boomi"
    service_component = "${var.molecule_type}-molecule"
    volume_status     = "active"
  }
}

resource "aws_autoscaling_group" "molecule" {
  name                 = "${var.env}-${var.molecule_type}-molecule"
  max_size             = "${var.molecule_max_size}"
  min_size             = "${var.molecule_min_size}"
  desired_capacity     = "${var.molecule_target_size}"
  vpc_zone_identifier  = ["${lookup(var.aws_subnet_natdc, "key0")}"]
  launch_configuration = "${aws_launch_configuration.molecule_node.id}"
  load_balancers       = ["${aws_elb.molecule.id}"]
  depends_on           = ["aws_ebs_volume.molecule"]

  tag {
    key                 = "Name"
    value               = "${var.env}-${var.molecule_type}-molecule-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "pipeline_phase"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "service_component"
    value               = "${var.molecule_type}-molecule"
    propagate_at_launch = true
  }

  tag {
    key                 = "jive_service"
    value               = "boomi"
    propagate_at_launch = true
  }

  tag {
    key                 = "region"
    value               = "${var.region}"
    propagate_at_launch = true
  }

  tag {
    key                 = "account_name"
    value               = "${var.aws_account_short_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "sla"
    value               = "${var.molecule_sla}"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "molecule" {
  name        = "${var.env}-${var.molecule_type}-molecule"
  description = "${var.molecule_type} molecule instances within the environment"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = 6
    security_groups = ["${aws_security_group.molecule_elb.id}"]
  }

  tags {
    pipeline_phase    = "${var.env}"
    region            = "${var.region}"
    account_name      = "${var.aws_account_short_name}"
    jive_service      = "boomi"
    service_component = "${var.molecule_type}-molecule"
    sla               = "${var.molecule_sla}"
  }
}

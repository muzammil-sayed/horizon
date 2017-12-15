resource "aws_security_group_rule" "mysql_port_3306" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.mysql_ports.id}"
}
resource "aws_security_group_rule" "mysql_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.mysql_ports.id}"
}
resource "aws_security_group" "mysql_ports" {
  name        = "${var.jive_subservice}_mysql_ports"
  description = "Allow traffic on ye olde MySQL port(s)"
  vpc_id      = "${var.aws_vpc_main}"
}

resource "template_file" "userdata" {
  template = "${file("${path.module}/userdata.sh")}"

  vars {
    region            = "${var.region}"
    pipeline_phase    = "${var.env}"
    account_name      = "${var.aws_account_short_name}"
    bundle_name       = "${var.ansible_bundle_name}"
    bundle_version    = "${var.ansible_bundle_version}"
    devices           = "${var.ebs_device}:${var.ebs_mountpoint}"
    skip_ebs_reattach = "" # set this to anything to skip the EBS reattachment script (will still format)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "mysql_node" {
  name_prefix                 = "${var.jive_subservice_short_name}-mysql-server-"
  image_id                    = "${var.mysql_image_id}"
  instance_type               = "${var.mysql_instance_type}"
  key_name                    = "${var.ec2_key_name}"
  iam_instance_profile        = "${var.ec2_instance_profile}"
  security_groups             = ["${var.aws_security_group_env_instance}", "${aws_security_group.mysql_ports.id}"]
  associate_public_ip_address = false
  ebs_optimized               = "${var.ebs_optimized}"

  lifecycle {
    create_before_destroy = true
  }

  ebs_block_device {
    device_name           = "${var.ebs_device}"
    volume_type           = "gp2"
    volume_size           = "${var.ebs_size}"
    delete_on_termination = false
    encrypted             = true
  }

  user_data = "${template_file.userdata.rendered}"
}

resource "aws_route53_record" "mysql_route53_alias" {
  zone_id = "${var.route53_data_jivehosted_zone_id}"
  name = "${var.env}-${var.jive_subservice_short_name}-mysql-master"
  type = "A"

  alias {
    name = "${aws_elb.mysql_master_elb.dns_name}"
    zone_id = "${aws_elb.mysql_master_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_elb" "mysql_master_elb" {
  name                        = "${var.jive_subservice}-mm"
  security_groups             = ["${var.aws_security_group_env_instance}", "${aws_security_group.mysql_ports.id}"]
  internal                    = true
  cross_zone_load_balancing   = true
  subnets                     = ["${lookup(var.aws_subnet_natdc, concat("key", "0"))}", "${lookup(var.aws_subnet_natdc, concat("key", "1"))}", "${lookup(var.aws_subnet_natdc, concat("key", "2"))}"]

  listener {
    instance_port             = 3306
    instance_protocol         = "tcp"
    lb_port                   = 3306
    lb_protocol               = "tcp"
  }
  health_check {
    healthy_threshold         = 2
    unhealthy_threshold       = 2
    timeout                   = 5
    target                    = "TCP:3306"
    interval                  = 10
  }

  tags {
    Name               = "${var.env}-${var.jive_subservice_short_name}-mysql-master"
    pipeline_phase     = "${var.env}"
    service_component  = "mysql_master"
    jive_service       = "${var.jive_service}"
    jive_subservice    = "${var.jive_subservice}"
    sla                = "${var.sla}"
  }

}

resource "aws_autoscaling_group" "mysql_master_asg_az1" {
  name                 = "${var.env}-${var.jive_subservice_short_name}-mysql-master-az1-asg"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${lookup(var.aws_subnet_natdc, concat("key", "0"))}"]
  launch_configuration = "${aws_launch_configuration.mysql_node.id}"
  load_balancers       = ["${aws_elb.mysql_master_elb.name}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.env}-${var.jive_subservice_short_name}-mysql-master"
    propagate_at_launch = true
  }

  tag {
    key                 = "pipeline_phase"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "service_component"
    value               = "mysql_master"
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

#  tag {
#    key                 = "region"
#    value               = "${var.region}"
#    propagate_at_launch = true
#  }

  tag {
    key                 = "sla"
    value               = "${var.sla}"
    propagate_at_launch = true
  }

#  tag {
#    key                 = "Account_name"
#    value               = "${var.aws_account_short_name}"
#    propagate_at_launch = true
#  }

}

resource "aws_autoscaling_group" "mysql_slave_asg_az1" {

  count = "${var.mysql_az1_create_slaves}"

  name                 = "${var.env}-${var.jive_subservice_short_name}-mysql-slave-az1-asg"
  max_size             = "${var.mysql_az1_number_of_slaves}"
  min_size             = "${var.mysql_az1_number_of_slaves}"
  vpc_zone_identifier  = ["${lookup(var.aws_subnet_natdc, concat("key", "0"))}"]
  launch_configuration = "${aws_launch_configuration.mysql_node.id}"
  load_balancers       = ["${aws_elb.mysql_slave_elb.name}"]

#  lifecycle {
#    create_before_destroy = true
#  }

  tag {
    key                 = "Name"
    value               = "${var.env}-${var.jive_subservice_short_name}-mysql-slave"
    propagate_at_launch = true
  }

  tag {
    key                 = "pipeline_phase"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "service_component"
    value               = "mysql_slave"
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

#  tag {
#    key                 = "region"
#    value               = "${var.region}"
#    propagate_at_launch = true
#  }

  tag {
    key                 = "sla"
    value               = "${var.sla}"
    propagate_at_launch = true
  }

#  tag {
#    key                 = "Account_name"
#    value               = "${var.aws_account_short_name}"
#    propagate_at_launch = true
#  }

}

resource "aws_autoscaling_group" "mysql_slave_asg_az2" {

  count = "${var.mysql_az2_create_slaves}"

  name                 = "${var.env}-${var.jive_subservice_short_name}-mysql-slave-az2-asg"
  max_size             = "${var.mysql_az1_number_of_slaves}"
  min_size             = "${var.mysql_az1_number_of_slaves}"
  vpc_zone_identifier  = ["${lookup(var.aws_subnet_natdc, concat("key", "1"))}"]
  launch_configuration = "${aws_launch_configuration.mysql_node.id}"
  load_balancers       = ["${aws_elb.mysql_slave_elb.name}"]

#  lifecycle {
#    create_before_destroy = true
#  }

  tag {
    key                 = "Name"
    value               = "${var.env}-${var.jive_subservice_short_name}-mysql-slave"
    propagate_at_launch = true
  }

  tag {
    key                 = "pipeline_phase"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "service_component"
    value               = "mysql_slave"
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

#  tag {
#    key                 = "region"
#    value               = "${var.region}"
#    propagate_at_launch = true
#  }

  tag {
    key                 = "sla"
    value               = "${var.sla}"
    propagate_at_launch = true
  }

#  tag {
#    key                 = "Account_name"
#    value               = "${var.aws_account_short_name}"
#    propagate_at_launch = true
#  }

}

resource "aws_autoscaling_group" "mysql_slave_asg_az3" {

  count = "${var.mysql_az3_create_slaves}"

  name                 = "${var.env}-${var.jive_subservice_short_name}-mysql-slave-az3-asg"
  max_size             = "${var.mysql_az3_number_of_slaves}"
  min_size             = "${var.mysql_az3_number_of_slaves}"
  vpc_zone_identifier  = ["${lookup(var.aws_subnet_natdc, concat("key", "2"))}"]
  launch_configuration = "${aws_launch_configuration.mysql_node.id}"
  load_balancers       = ["${aws_elb.mysql_slave_elb.name}"]

#  lifecycle {
#    create_before_destroy = true
#  }

  tag {
    key                 = "Name"
    value               = "${var.env}-${var.jive_subservice_short_name}-mysql-slave"
    propagate_at_launch = true
  }

  tag {
    key                 = "pipeline_phase"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "service_component"
    value               = "mysql_slave"
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

#  tag {
#    key                 = "region"
#    value               = "${var.region}"
#    propagate_at_launch = true
#  }

  tag {
    key                 = "sla"
    value               = "${var.sla}"
    propagate_at_launch = true
  }

#  tag {
#    key                 = "Account_name"
#    value               = "${var.aws_account_short_name}"
#    propagate_at_launch = true
#  }

}

resource "aws_elb" "mysql_slave_elb" {

  count = "${var.mysql_create_slave_elb}"

  name                        = "${var.jive_subservice}-mysql-slave-elb"
  security_groups             = ["${var.aws_security_group_env_instance}", "${aws_security_group.mysql_ports.id}"]
  internal                    = true
  cross_zone_load_balancing   = true
  subnets                     = ["${lookup(var.aws_subnet_natdc, concat("key", "0"))}", "${lookup(var.aws_subnet_natdc, concat("key", "1"))}", "${lookup(var.aws_subnet_natdc, concat("key", "2"))}"]

  listener {
    instance_port             = 3306
    instance_protocol         = "tcp"
    lb_port                   = 3306
    lb_protocol               = "tcp"
  }

  health_check {
    healthy_threshold         = 2
    unhealthy_threshold       = 2
    timeout                   = 5
    target                    = "TCP:3306"
    interval                  = 10
  }

  tags {
    Name               = "${var.env}-${var.jive_subservice_short_name}-mysql-slave"
    pipeline_phase     = "${var.env}"
    service_component  = "mysql_slave"
    jive_service       = "${var.jive_service}"
    jive_subservice    = "${var.jive_subservice}"
    sla                = "${var.sla}"
  }

}


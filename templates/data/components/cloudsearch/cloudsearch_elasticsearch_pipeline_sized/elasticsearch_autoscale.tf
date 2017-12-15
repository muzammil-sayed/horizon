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

resource "aws_security_group_rule" "kibana_port_5601" {
  type              = "ingress"
  from_port         = 5601
  to_port           = 5601
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.kibana_ports.id}"
}

resource "aws_security_group_rule" "http_port_80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.http_port_80.id}"
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
  name        = "${var.jive_service}_elasticsearch_ports"
  description = "Allow traffic on ye olde elasticsearch ports"
  vpc_id      = "${var.aws_vpc_main}"
}
resource "aws_security_group" "kibana_ports" {
  name        = "${var.jive_service}_kibana_ports"
  description = "Allow traffic on ye olde kibana ports"
  vpc_id      = "${var.aws_vpc_main}"
}
resource "aws_security_group" "http_port_80" {
  name        = "${var.jive_service}_http_port_80"
  description = "Allow standard http traffic on port 80"
  vpc_id      = "${var.aws_vpc_main}"
}
resource "template_file" "elasticsearch_user_data" {
  template = "${file("${path.module}/elasticsearch_user_data.sh")}"

  vars {
    region            = "${var.region}"
    pipeline_phase    = "${var.env}"
    account_name      = "${var.aws_account_short_name}"
    bundle_name       = "com.jivesoftware.techops:ansible-cloudsearch-elasticsearch:LATEST"
    bundle_short_name = "${var.jive_service}"
    devices           = "/dev/xvdm:/data/elasticsearch"
    skip_ebs_reattach = "" # set this to anything to skip the EBS reattachment script (will still format)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "cloudsearch-elasticsearch-elb" {
  name                        = "cloudsearch-elasticsearch-elb"
  security_groups             = ["${var.aws_security_group_env_instance}", "${aws_security_group.elasticsearch_ports.id}"]
  internal                    = true
  cross_zone_load_balancing   = true
  subnets                     = ["${lookup(var.aws_subnet_natdc, concat("key", "0"))}", "${lookup(var.aws_subnet_natdc, concat("key", "1"))}", "${lookup(var.aws_subnet_natdc, concat("key", "2"))}"]

  listener {
    instance_port             = 9200
    instance_protocol         = "http"
    lb_port                   = 9200
    lb_protocol               = "http"
  }

  health_check {
    healthy_threshold         = 2
    unhealthy_threshold       = 2
    timeout                   = 5
    target                    = "HTTP:9200/_cluster/health"
    interval                  = 10
  }

}

resource "aws_route53_record" "elasticsearch-search-integ" {
  zone_id = "${var.route53_data_zone_id}"
  name = "aws-integ-cloudsearch-es"
  type = "A"

  alias {
    name = "${aws_elb.cloudsearch-elasticsearch-elb.dns_name}"
    zone_id = "${aws_elb.cloudsearch-elasticsearch-elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_elb" "cloudsearch-kibana-elb" {
  name                        = "cloudsearch-kibana-elb"
  security_groups             = ["${var.aws_security_group_env_instance}", "${aws_security_group.http_port_80.id}"]
  internal                    = true
  cross_zone_load_balancing   = false
  subnets                     = ["${lookup(var.aws_subnet_natdc, concat("key", "0"))}"]

  listener {
    instance_port             = 5601
    instance_protocol         = "http"
    lb_port                   = 80
    lb_protocol               = "http"
  }

  health_check {
    healthy_threshold         = 2
    unhealthy_threshold       = 2
    timeout                   = 5
    target                    = "HTTP:5601/"
    interval                  = 10
  }

}

resource "aws_route53_record" "kibana-search-integ" {
  zone_id = "${var.route53_data_zone_id}"
  name = "kibana-search-integ"
  type = "A"

  alias {
    name = "${aws_elb.cloudsearch-kibana-elb.dns_name}"
    zone_id = "${aws_elb.cloudsearch-kibana-elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_launch_configuration" "elasticsearch_node" {
  name_prefix                 = "${var.jive_service_short_name}-elasticsearch-node-"
  image_id                    = "ami-d2c924b2"
  #instance_type               = "r3.2xlarge"
  instance_type               = "r3.xlarge"
  key_name                    = "data-pipeline"
  #iam_instance_profile        = "${aws_iam_instance_profile.ebs-attach.id}"
  iam_instance_profile        = "ebs-attach-profile"
  security_groups             = ["${var.aws_security_group_env_instance}", "${aws_security_group.elasticsearch_ports.id}"]
  associate_public_ip_address = false
  ebs_optimized               = true

  lifecycle {
    create_before_destroy = true
  }

  ebs_block_device {
    device_name           = "/dev/xvdm"
    volume_type           = "gp2"
    volume_size           = "500"
    delete_on_termination = false
    encrypted             = true
  }

  user_data = "${template_file.elasticsearch_user_data.rendered}"
}

resource "aws_launch_configuration" "kibana_elasticsearch_node" {
  name_prefix                 = "${var.jive_service_short_name}-elasticsearch-node-"
  image_id                    = "ami-d2c924b2"
  #instance_type               = "r3.2xlarge"
  instance_type               = "r3.xlarge"
  key_name                    = "data-pipeline"
  #iam_instance_profile        = "${aws_iam_instance_profile.ebs-attach.id}"
  iam_instance_profile        = "ebs-attach-profile"
  security_groups             = ["${var.aws_security_group_env_instance}", "${aws_security_group.elasticsearch_ports.id}", "${aws_security_group.kibana_ports.id}"]
  associate_public_ip_address = false
  ebs_optimized               = true

  lifecycle {
    create_before_destroy = true
  }

  ebs_block_device {
    device_name           = "/dev/xvdm"
    volume_type           = "gp2"
    volume_size           = "500"
    delete_on_termination = false
    encrypted             = true
  }

  user_data = "${template_file.elasticsearch_user_data.rendered}"
}

resource "aws_autoscaling_group" "elasticsearch_node_asg_az1" {
  name                 = "${var.env}-${var.jive_service_short_name}-es-node-az1-asg"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${lookup(var.aws_subnet_natdc, concat("key", "0"))}"]
  launch_configuration = "${aws_launch_configuration.kibana_elasticsearch_node.id}"
  load_balancers       = ["${aws_elb.cloudsearch-elasticsearch-elb.name}", "${aws_elb.cloudsearch-kibana-elb.name}"]
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.env}-${var.jive_service_short_name}-es-node"
    propagate_at_launch = true
  }

 tag {
    key                 = "Kibana_node"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "pipeline_phase"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "service_component"
    value               = "es_master01"
    propagate_at_launch = true
  }

  tag {
    key                 = "jive_service"
    value               = "${var.jive_service}"
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

}

resource "aws_autoscaling_group" "elasticsearch_node_asg_az2" {
  name                 = "${var.env}-${var.jive_service_short_name}-es-node-az2-asg"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${lookup(var.aws_subnet_natdc, concat("key", "1"))}"]
  launch_configuration = "${aws_launch_configuration.elasticsearch_node.id}"
  load_balancers       = ["${aws_elb.cloudsearch-elasticsearch-elb.name}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.env}-${var.jive_service_short_name}-es-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "pipeline_phase"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "service_component"
    value               = "es_master02"
    propagate_at_launch = true
  }

  tag {
    key                 = "jive_service"
    value               = "${var.jive_service}"
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

}

resource "aws_autoscaling_group" "elasticsearch_node_asg_az3" {
  name                 = "${var.env}-${var.jive_service_short_name}-es-node-az3-asg"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${lookup(var.aws_subnet_natdc, concat("key", "2"))}"]
  launch_configuration = "${aws_launch_configuration.elasticsearch_node.id}"
  load_balancers       = ["${aws_elb.cloudsearch-elasticsearch-elb.name}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.env}-${var.jive_service_short_name}-es-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "pipeline_phase"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "service_component"
    value               = "es_master03"
    propagate_at_launch = true
  }

  tag {
    key                 = "jive_service"
    value               = "${var.jive_service}"
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

}


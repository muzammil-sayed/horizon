resource "aws_security_group_rule" "logstash_port_9601" {
  type              = "ingress"
  from_port         = 9601
  to_port           = 9601
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.logstash_ports.id}"
}

resource "aws_security_group_rule" "logstash_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.logstash_ports.id}"
}

resource "aws_security_group" "logstash_ports" {
  name        = "${var.jive_service}_logstash_ports"
  description = "${var.jive_service_short_name} logstash FTW"
  vpc_id      = "${var.aws_vpc_main}"
}

data "template_file" "logstash_bootstrap" {
  template = "${file("${path.module}/bootstrap.sh")}"
}

resource "aws_instance" "blammo_logstash1" {
  availability_zone           = "us-west-2a"
  ami                         = "${var.ami_id}"
  instance_type               = "${var.logstash_instance_size}"
  iam_instance_profile        = "ebs-attach-profile"
  vpc_security_group_ids      = ["${var.aws_security_group_env_instance}", "${aws_security_group.logstash_ports.id}"]
  subnet_id                   = "${var.uswesta_vpc_subnet_id}"
  associate_public_ip_address = false
  ebs_optimized               = false
  key_name                    = "${var.ec2_key_name}"
  user_data                   = "${data.template_file.logstash_bootstrap.rendered}"

  tags {
    "Name"              = "blammo-logstash1"
    "pipeline_phase"    = "${var.env}"
    "service_component" = "logstash"
    "jive_service"      = "${var.jive_service}"
    "region"            = "${var.region}"
    "sla"               = "${var.sla}"
    "account_name"      = "${var.aws_account_short_name}"
    "role"              = "master"
  }

}

resource "aws_instance" "blammo_logstash2" {
  availability_zone           = "us-west-2b"
  ami                         = "${var.ami_id}"
  instance_type               = "${var.logstash_instance_size}"
  iam_instance_profile        = "ebs-attach-profile"
  vpc_security_group_ids      = ["${var.aws_security_group_env_instance}", "${aws_security_group.logstash_ports.id}"]
  subnet_id                   = "${var.uswestb_vpc_subnet_id}"
  associate_public_ip_address = false
  ebs_optimized               = false
  key_name                    = "${var.ec2_key_name}"
  user_data                   = "${data.template_file.logstash_bootstrap.rendered}"

  tags {
    "Name"              = "blammo-logstash2"
    "pipeline_phase"    = "${var.env}"
    "service_component" = "logstash"
    "jive_service"      = "${var.jive_service}"
    "region"            = "${var.region}"
    "sla"               = "${var.sla}"
    "account_name"      = "${var.aws_account_short_name}"
    "role"              = "slave"
  }

}

resource "aws_instance" "blammo_logstash3" {
  availability_zone           = "us-west-2c"
  ami                         = "${var.ami_id}"
  instance_type               = "${var.logstash_instance_size}"
  iam_instance_profile        = "ebs-attach-profile"
  vpc_security_group_ids      = ["${var.aws_security_group_env_instance}", "${aws_security_group.logstash_ports.id}"]
  subnet_id                   = "${var.uswestc_vpc_subnet_id}"
  associate_public_ip_address = false
  ebs_optimized               = false
  key_name                    = "${var.ec2_key_name}"
  user_data                   = "${data.template_file.logstash_bootstrap.rendered}"

  tags {
    "Name"              = "blammo-logstash3"
    "pipeline_phase"    = "${var.env}"
    "service_component" = "logstash"
    "jive_service"      = "${var.jive_service}"
    "region"            = "${var.region}"
    "sla"               = "${var.sla}"
    "account_name"      = "${var.aws_account_short_name}"
    "role"              = "slave"
  }

}

resource "aws_route53_record" "blammo-logstash1" {
  zone_id = "${var.route53_public_data_zone_id}"
  name = "blammo-logstash1"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.blammo_logstash1.private_ip}"]
}

resource "aws_route53_record" "blammo-logstash2" {
  zone_id = "${var.route53_public_data_zone_id}"
  name = "blammo-logstash2"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.blammo_logstash2.private_ip}"]
}

resource "aws_route53_record" "blammo-logstash3" {
  zone_id = "${var.route53_public_data_zone_id}"
  name = "blammo-logstash3"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.blammo_logstash3.private_ip}"]
}

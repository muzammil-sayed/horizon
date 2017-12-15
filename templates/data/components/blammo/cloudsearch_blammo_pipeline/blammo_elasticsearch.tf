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
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.elasticsearch_ports.id}"
}

resource "aws_security_group" "elasticsearch_ports" {
  name        = "${var.jive_service}_elasticsearch_ports"
  description = "${var.jive_service_short_name} elasticsearch FTW"
  vpc_id      = "${var.aws_vpc_main}"
}

data "template_file" "bootstrap" {
  template = "${file("${path.module}/bootstrap.sh")}"
}

resource "aws_instance" "blammo_es1" {
  availability_zone           = "us-west-2a"
  ami                         = "${var.ami_id}"
  instance_type               = "${var.instance_size}"
  iam_instance_profile        = "ebs-attach-profile"
  vpc_security_group_ids      = ["${var.aws_security_group_env_instance}", "${aws_security_group.elasticsearch_ports.id}"]
  subnet_id                   = "${var.uswesta_vpc_subnet_id}"
  associate_public_ip_address = false
  ebs_optimized               = false
  key_name                    = "${var.ec2_key_name}"
  user_data                   = "${data.template_file.bootstrap.rendered}"

  tags {
    "Name"              = "blammo-es1"
    "pipeline_phase"    = "${var.env}"
    "service_component" = "elasticsearch"
    "jive_service"      = "${var.jive_service}"
    "region"            = "${var.region}"
    "sla"               = "${var.sla}"
    "account_name"      = "${var.aws_account_short_name}"
    "role"              = "master"
  }

}

resource "aws_instance" "blammo_es2" {
  availability_zone           = "us-west-2b"
  ami                         = "${var.ami_id}"
  instance_type               = "${var.instance_size}"
  iam_instance_profile        = "ebs-attach-profile"
  vpc_security_group_ids      = ["${var.aws_security_group_env_instance}", "${aws_security_group.elasticsearch_ports.id}"]
  subnet_id                   = "${var.uswestb_vpc_subnet_id}"
  associate_public_ip_address = false
  ebs_optimized               = false
  key_name                    = "${var.ec2_key_name}"
  user_data                   = "${data.template_file.bootstrap.rendered}"

  tags {
    "Name"              = "blammo-es2"
    "pipeline_phase"    = "${var.env}"
    "service_component" = "elasticsearch"
    "jive_service"      = "${var.jive_service}"
    "region"            = "${var.region}"
    "sla"               = "${var.sla}"
    "account_name"      = "${var.aws_account_short_name}"
    "role"              = "slave"
  }

}

resource "aws_instance" "blammo_es3" {
  availability_zone           = "us-west-2c"
  ami                         = "${var.ami_id}"
  instance_type               = "${var.instance_size}"
  iam_instance_profile        = "ebs-attach-profile"
  vpc_security_group_ids      = ["${var.aws_security_group_env_instance}", "${aws_security_group.elasticsearch_ports.id}"]
  subnet_id                   = "${var.uswestc_vpc_subnet_id}"
  associate_public_ip_address = false
  ebs_optimized               = false
  key_name                    = "${var.ec2_key_name}"
  user_data                   = "${data.template_file.bootstrap.rendered}"

  tags {
    "Name"              = "blammo-es3"
    "pipeline_phase"    = "${var.env}"
    "service_component" = "elasticsearch"
    "jive_service"      = "${var.jive_service}"
    "region"            = "${var.region}"
    "sla"               = "${var.sla}"
    "account_name"      = "${var.aws_account_short_name}"
    "role"              = "slave"
  }

}

resource "aws_route53_record" "blammo-es1" {
  zone_id = "${var.route53_public_data_zone_id}"
  name = "blammo-es1"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.blammo_es1.private_ip}"]
}

resource "aws_route53_record" "blammo-es2" {
  zone_id = "${var.route53_public_data_zone_id}"
  name = "blammo-es2"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.blammo_es2.private_ip}"]
}

resource "aws_route53_record" "blammo-es3" {
  zone_id = "${var.route53_public_data_zone_id}"
  name = "blammo-es3"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.blammo_es3.private_ip}"]
}

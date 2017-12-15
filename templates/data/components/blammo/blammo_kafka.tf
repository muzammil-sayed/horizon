resource "aws_security_group_rule" "kafka_insecure_port_9093" {
  type              = "ingress"
  from_port         = 9092
  to_port           = 9092
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.kafka_ports.id}"
}

resource "aws_security_group_rule" "kafka_secure_port_9093" {
  type              = "ingress"
  from_port         = 9093
  to_port           = 9093
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.kafka_ports.id}"
}

resource "aws_security_group_rule" "zookeeper_port_2181" {
  type              = "ingress"
  from_port         = 2181
  to_port           = 2181
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.kafka_ports.id}"
}

resource "aws_security_group_rule" "kafka_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.kafka_ports.id}"
}

resource "aws_security_group" "kafka_ports" {
  name        = "${var.jive_service}_kafka_ports"
  description = "${var.jive_service_short_name} kafka FTW"
  vpc_id      = "${var.aws_vpc_main}"
}

data "template_file" "kafka_bootstrap" {
  template = "${file("${path.module}/bootstrap.sh")}"
}

resource "aws_instance" "blammo_kafka1" {
  availability_zone           = "us-west-2a"
  ami                         = "${var.ami_id}"
  instance_type               = "${var.kafka_instance_size}"
  iam_instance_profile        = "ebs-attach-profile"
  vpc_security_group_ids      = ["${var.aws_security_group_env_instance}", "${aws_security_group.kafka_ports.id}"]
  subnet_id                   = "${var.uswesta_vpc_subnet_id}"
  associate_public_ip_address = false
  ebs_optimized               = false
  key_name                    = "${var.ec2_key_name}"
  user_data                   = "${data.template_file.kafka_bootstrap.rendered}"
  ephemeral_block_device {
    device_name = "/dev/sdb"
    virtual_name = "ephemeral0"
  }

  ephemeral_block_device {
    device_name = "/dev/sdc"
    virtual_name = "ephemeral1"
  }

  tags {
    "Name"              = "blammo-kafka1"
    "pipeline_phase"    = "${var.env}"
    "service_component" = "kafka"
    "jive_service"      = "${var.jive_service}"
    "region"            = "${var.region}"
    "sla"               = "${var.sla}"
    "account_name"      = "${var.aws_account_short_name}"
    "role"              = "master"
  }

}

resource "aws_instance" "blammo_kafka2" {
  availability_zone           = "us-west-2b"
  ami                         = "${var.ami_id}"
  instance_type               = "${var.kafka_instance_size}"
  iam_instance_profile        = "ebs-attach-profile"
  vpc_security_group_ids      = ["${var.aws_security_group_env_instance}", "${aws_security_group.kafka_ports.id}"]
  subnet_id                   = "${var.uswestb_vpc_subnet_id}"
  associate_public_ip_address = false
  ebs_optimized               = false
  key_name                    = "${var.ec2_key_name}"
  user_data                   = "${data.template_file.kafka_bootstrap.rendered}"
  ephemeral_block_device {
    device_name = "/dev/sdb"
    virtual_name = "ephemeral0"
  }

  ephemeral_block_device {
    device_name = "/dev/sdc"
    virtual_name = "ephemeral1"
  }

  tags {
    "Name"              = "blammo-kafka2"
    "pipeline_phase"    = "${var.env}"
    "service_component" = "kafka"
    "jive_service"      = "${var.jive_service}"
    "region"            = "${var.region}"
    "sla"               = "${var.sla}"
    "account_name"      = "${var.aws_account_short_name}"
    "role"              = "slave"
  }

}

resource "aws_instance" "blammo_kafka3" {
  availability_zone           = "us-west-2c"
  ami                         = "${var.ami_id}"
  instance_type               = "${var.kafka_instance_size}"
  iam_instance_profile        = "ebs-attach-profile"
  vpc_security_group_ids      = ["${var.aws_security_group_env_instance}", "${aws_security_group.kafka_ports.id}"]
  subnet_id                   = "${var.uswestc_vpc_subnet_id}"
  associate_public_ip_address = false
  ebs_optimized               = false
  key_name                    = "${var.ec2_key_name}"
  user_data                   = "${data.template_file.kafka_bootstrap.rendered}"
  ephemeral_block_device {
    device_name = "/dev/sdb"
    virtual_name = "ephemeral0"
  }

  ephemeral_block_device {
    device_name = "/dev/sdc"
    virtual_name = "ephemeral1"
  }

  tags {
    "Name"              = "blammo-kafka3"
    "pipeline_phase"    = "${var.env}"
    "service_component" = "kafka"
    "jive_service"      = "${var.jive_service}"
    "region"            = "${var.region}"
    "sla"               = "${var.sla}"
    "account_name"      = "${var.aws_account_short_name}"
    "role"              = "slave"
  }

}

resource "aws_route53_record" "blammo-kafka1" {
  zone_id = "${var.route53_public_data_zone_id}"
  name = "blammo-kafka1"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.blammo_kafka1.private_ip}"]
}

resource "aws_route53_record" "blammo-kafka2" {
  zone_id = "${var.route53_public_data_zone_id}"
  name = "blammo-kafka2"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.blammo_kafka2.private_ip}"]
}

resource "aws_route53_record" "blammo-kafka3" {
  zone_id = "${var.route53_public_data_zone_id}"
  name = "blammo-kafka3"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.blammo_kafka3.private_ip}"]
}

resource "aws_security_group_rule" "redis_port_6379" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.redis_ports.id}"
}

resource "aws_security_group_rule" "redis_port_16379" {
  type              = "ingress"
  from_port         = 16379
  to_port           = 16379
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.redis_ports.id}"
}

resource "aws_security_group_rule" "redis_port_26379" {
  type              = "ingress"
  from_port         = 26379
  to_port           = 26379
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.redis_ports.id}"
}

resource "aws_security_group_rule" "redis_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.redis_ports.id}"
}

resource "aws_security_group" "redis_ports" {
  name        = "${var.jive_service}_redis_ports"
  description = "Redis FTW"
  vpc_id      = "${var.aws_vpc_main}"
}

resource "template_file" "redis_bootstrap" {
  template = "${file("${path.module}/redis_bootstrap.sh")}"

  vars {
    region            = "${var.region}"
    pipeline_phase    = "${var.env}"
    bundle_name       = "com.jivesoftware.techops:ansible-cloudsearch-elasticsearch:LATEST"
    bundle_short_name = "${var.jive_service}"
    account_name      = "${var.aws_account_short_name}"
    devices           = "/dev/xvdm:/data/redis"
    skip_ebs_reattach = "true" # set this to anything to skip the EBS reattachment script (will still format)
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "redis_az1" {
  availability_zone           = "us-west-2a"
  ami                         = "${var.ami_id}"
  instance_type               = "t2.medium"
  iam_instance_profile        = "ebs-attach-profile"
  vpc_security_group_ids      = ["${var.aws_security_group_env_instance}", "${aws_security_group.redis_ports.id}"]
  subnet_id                   = "${var.uswesta_vpc_subnet_id}"
  associate_public_ip_address = false
  ebs_optimized               = false
  key_name                    = "${var.ec2_key_name}"

  ebs_block_device {
    device_name           = "/dev/xvdm"
    volume_type           = "gp2"
    volume_size           = "20"
    delete_on_termination = false
    encrypted             = true
  }

  user_data             = "${template_file.redis_bootstrap.rendered}"

  tags {
    "Name"              = "redis01-search"
    "pipeline_phase"    = "${var.env}"
    "service_component" = "redis"
    "jive_service"      = "${var.jive_service}"
    "region"            = "${var.region}"
    "sla"               = "${var.sla}"
    "account_name"      = "${var.aws_account_short_name}"
    "role"              = "master"
  }

}

resource "aws_instance" "redis_az2" {
  availability_zone           = "us-west-2b"
  ami                         = "${var.ami_id}"
  instance_type               = "t2.medium"
  iam_instance_profile        = "ebs-attach-profile"
  vpc_security_group_ids      = ["${var.aws_security_group_env_instance}", "${aws_security_group.redis_ports.id}"]
  subnet_id                   = "${var.uswestb_vpc_subnet_id}"
  associate_public_ip_address = false
  ebs_optimized               = false
  key_name                    = "${var.ec2_key_name}"

  ebs_block_device {
    device_name           = "/dev/xvdm"
    volume_type           = "gp2"
    volume_size           = "20"
    delete_on_termination = false
    encrypted             = true
  }

  user_data             = "${template_file.redis_bootstrap.rendered}"

  tags {
    "Name"              = "redis02-search"
    "pipeline_phase"    = "${var.env}"
    "service_component" = "redis"
    "jive_service"      = "${var.jive_service}"
    "region"            = "${var.region}"
    "sla"               = "${var.sla}"
    "account_name"      = "${var.aws_account_short_name}"
    "role"              = "slave"
  }

}

resource "aws_instance" "search_redis1" {
  availability_zone           = "us-west-2a"
  ami                         = "${var.ami_id}"
  instance_type               = "t2.medium"
  iam_instance_profile        = "ebs-attach-profile"
  vpc_security_group_ids      = ["${var.aws_security_group_env_instance}", "${aws_security_group.redis_ports.id}"]
  subnet_id                   = "${var.uswesta_vpc_subnet_id}"
  associate_public_ip_address = false
  ebs_optimized               = false
  key_name                    = "${var.ec2_key_name}"

  ebs_block_device {
    device_name           = "/dev/xvdm"
    volume_type           = "gp2"
    volume_size           = "20"
    delete_on_termination = false
    encrypted             = true
  }

  user_data             = "${template_file.redis_bootstrap.rendered}"

  tags {
    "Name"              = "search-redis1"
    "pipeline_phase"    = "${var.env}"
    "service_component" = "redis"
    "jive_service"      = "${var.jive_service}"
    "region"            = "${var.region}"
    "sla"               = "${var.sla}"
    "account_name"      = "${var.aws_account_short_name}"
    "role"              = "master"
  }

}

resource "aws_instance" "search_redis2" {
  availability_zone           = "us-west-2b"
  ami                         = "${var.ami_id}"
  instance_type               = "t2.medium"
  iam_instance_profile        = "ebs-attach-profile"
  vpc_security_group_ids      = ["${var.aws_security_group_env_instance}", "${aws_security_group.redis_ports.id}"]
  subnet_id                   = "${var.uswestb_vpc_subnet_id}"
  associate_public_ip_address = false
  ebs_optimized               = false
  key_name                    = "${var.ec2_key_name}"

  ebs_block_device {
    device_name           = "/dev/xvdm"
    volume_type           = "gp2"
    volume_size           = "20"
    delete_on_termination = false
    encrypted             = true
  }

  user_data             = "${template_file.redis_bootstrap.rendered}"

  tags {
    "Name"              = "search-redis2"
    "pipeline_phase"    = "${var.env}"
    "service_component" = "redis"
    "jive_service"      = "${var.jive_service}"
    "region"            = "${var.region}"
    "sla"               = "${var.sla}"
    "account_name"      = "${var.aws_account_short_name}"
    "role"              = "slave"
  }

}

resource "aws_instance" "search_redis3" {
  availability_zone           = "us-west-2c"
  ami                         = "${var.ami_id}"
  instance_type               = "t2.medium"
  iam_instance_profile        = "ebs-attach-profile"
  vpc_security_group_ids      = ["${var.aws_security_group_env_instance}", "${aws_security_group.redis_ports.id}"]
  subnet_id                   = "${var.uswestc_vpc_subnet_id}"
  associate_public_ip_address = false
  ebs_optimized               = false
  key_name                    = "${var.ec2_key_name}"

  ebs_block_device {
    device_name           = "/dev/xvdm"
    volume_type           = "gp2"
    volume_size           = "20"
    delete_on_termination = false
    encrypted             = true
  }

  user_data             = "${template_file.redis_bootstrap.rendered}"

  tags {
    "Name"              = "search-redis3"
    "pipeline_phase"    = "${var.env}"
    "service_component" = "redis"
    "jive_service"      = "${var.jive_service}"
    "region"            = "${var.region}"
    "sla"               = "${var.sla}"
    "account_name"      = "${var.aws_account_short_name}"
    "role"              = "slave"
  }

}

resource "aws_route53_record" "search-redis1" {
  zone_id = "${var.route53_databrewprod_zone_id}"
  name = "search-redis1"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.search_redis1.private_ip}"]
}

resource "aws_route53_record" "search-redis2" {
  zone_id = "${var.route53_databrewprod_zone_id}"
  name = "search-redis2"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.search_redis2.private_ip}"]
}

resource "aws_route53_record" "search-redis3" {
  zone_id = "${var.route53_databrewprod_zone_id}"
  name = "search-redis3"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.search_redis3.private_ip}"]
}

resource "aws_route53_record" "redis01-search" {
  zone_id = "${var.route53_databrewprod_zone_id}"
  name = "redis01-search"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.redis_az1.private_ip}"]
}

resource "aws_route53_record" "redis02-search" {
  zone_id = "${var.route53_databrewprod_zone_id}"
  name = "redis02-search"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.redis_az2.private_ip}"]
}

resource "aws_elb" "molecule" {
  name            = "${var.env}-${var.molecule_type}-molecule"
  security_groups = ["${aws_security_group.molecule_elb.id}"]
  subnets         = ["${lookup(var.aws_subnet_public, "key0")}", "${lookup(var.aws_subnet_public, "key1")}"]

  #instances = ["${aws_instance.molecule_node.*.id}"]
  idle_timeout              = 60
  cross_zone_load_balancing = true

  listener {
    lb_port            = 443
    lb_protocol        = "HTTPS"
    ssl_certificate_id = "${var.elb_cert_arn}"
    instance_protocol  = "http"
    instance_port      = 8080
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 15
  }

  tags {
    pipeline_phase    = "${var.env}"
    region            = "${var.region}"
    account_name      = "${var.aws_account_short_name}"
    jive_service      = "boomi"
    service_component = "${var.molecule_type}-molecule"
  }
}

resource "aws_security_group" "molecule_elb" {
  name        = "${var.env}-${var.molecule_type}-molecule_elb"
  description = "Access to molecule elb"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    pipeline_phase    = "${var.env}"
    region            = "${var.region}"
    account_name      = "${var.aws_account_short_name}"
    jive_service      = "boomi"
    service_component = "${var.molecule_type}-molecule"
  }
}

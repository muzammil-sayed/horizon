resource "aws_security_group" "resonata" {
  name        = "resonata-${var.env}"
  description = "Resonata ${var.env}"
  vpc_id      = "${var.aws_vpc_main}"
}

resource "aws_security_group_rule" "resonata_flower" {
  type              = "ingress"
  from_port         = 5555
  to_port           = 5555
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.resonata.id}"
}

resource "aws_security_group_rule" "resonata_hurricane" {
  type              = "ingress"
  from_port         = 9050
  to_port           = 9050
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.resonata.id}"
}

resource "aws_security_group_rule" "resonata_rabbitmq" {
  type              = "ingress"
  from_port         = 15672
  to_port           = 15672
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.resonata.id}"
}

resource "aws_security_group_rule" "resonata_mongo" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.resonata.id}"
}

resource "aws_security_group_rule" "resonata_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/8"]
  security_group_id = "${aws_security_group.resonata.id}"
}

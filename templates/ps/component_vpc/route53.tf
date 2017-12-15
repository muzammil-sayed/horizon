resource "aws_route53_zone_association" "route53" {
  zone_id = "${var.route53_zone_id}"
  vpc_id  = "${aws_vpc.main.id}"
}

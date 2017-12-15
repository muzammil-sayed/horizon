resource "aws_route53_record" "resonata" {
  zone_id = "${var.jiveprivate_zone_id}"
  name    = "${var.env}-${var.jive_subservice_short_name}-resonata"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.resonata.private_ip}"]
}

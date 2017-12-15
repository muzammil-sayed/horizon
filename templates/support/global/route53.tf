### VPC for Route53 ###
resource "aws_vpc" "route53" {
  cidr_block           = "172.32.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name         = "route53-default-vpc"
    jive_service = "infrastructure"
    region       = "${var.region}"
    account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_zone" "jiveprivate" {
  name    = "jiveprivate.com"
  comment = "Private domain for ${var.aws_account_short_name}"
  vpc_id  = "${aws_vpc.route53.id}"

  tags {
    Name         = "jiveprivate.com"
    jive_service = "infrastructure"
    region       = "${var.region}"
    account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_record" "ldap" {
  zone_id = "${aws_route53_zone.jiveprivate.zone_id}"
  name    = "ldap.jiveprivate.com"
  type    = "A"
  ttl     = "60"
  records = ["${var.ldap_ip}"]
}

resource "aws_route53_record" "ldap_cname" {
  zone_id = "${aws_route53_zone.jiveprivate.zone_id}"
  name    = "ldap.${var.env}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_route53_record.ldap.fqdn}"]
}

resource "aws_route53_record" "nexus" {
  zone_id = "${aws_route53_zone.jiveprivate.zone_id}"
  name    = "nexus.jiveprivate.com"
  type    = "A"
  ttl     = "60"
  records = ["${var.nexus_ip}"]
}

resource "aws_route53_record" "nexus_cname" {
  zone_id = "${aws_route53_zone.jiveprivate.zone_id}"
  name    = "nexus.${var.env}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_route53_record.nexus.fqdn}"]
}

resource "aws_route53_record" "stash" {
  zone_id = "${aws_route53_zone.jiveprivate.zone_id}"
  name    = "stash.jiveprivate.com"
  type    = "A"
  ttl     = "60"
  records = ["${var.stash_ip}"]
}

resource "aws_route53_record" "stash_cname" {
  zone_id = "${aws_route53_zone.jiveprivate.zone_id}"
  name    = "stash.${var.env}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_route53_record.stash.fqdn}"]
}

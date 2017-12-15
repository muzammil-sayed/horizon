### VPC for Route53 ###
resource "aws_vpc" "route53" {
  cidr_block           = "172.32.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name         = "route53-default-vpc"
    Jive_service = "infrastructure"
    Region       = "${var.region}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_zone" "jiveprivate" {
  name    = "jiveprivate.com"
  comment = "Private domain for ${var.aws_account_short_name}"
  vpc_id  = "${aws_vpc.route53.id}"

  tags {
    Name         = "jiveprivate.com"
    Jive_service = "infrastructure"
    Region       = "${var.region}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_record" "ldap" {
  zone_id = "${aws_route53_zone.jiveprivate.zone_id}"
  name    = "ldap.jiveprivate.com"
  type    = "A"
  ttl     = "60"
  records = ["${var.ldap_ip}"]
  set_identifier = "ldap_default"
  geolocation_routing_policy {
    country = "*"
  }
}

resource "aws_route53_record" "ldap_na" {
  zone_id = "${aws_route53_zone.jiveprivate.zone_id}"
  name    = "ldap.jiveprivate.com"
  type    = "A"
  ttl     = "60"
  records = ["${var.ldap_phx_ip}"]
  set_identifier = "ldap_na"
  geolocation_routing_policy {
    continent = "NA"
  }
}

resource "aws_route53_record" "ldap_eu" {
  zone_id = "${aws_route53_zone.jiveprivate.zone_id}"
  name    = "ldap.jiveprivate.com"
  type    = "A"
  ttl     = "60"
  records = ["${var.ldap_ams_ip}"]
  depends_on    = ["aws_route53_record.ldap"]
  set_identifier = "ldap_eu"
  geolocation_routing_policy {
    continent = "EU"
  }
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

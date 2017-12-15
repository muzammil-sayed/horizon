### Services Route53 Zone Records ###
# Creating these records in infra-pipeline is fine, just ignore them
# 2017-04-12 - Devon

resource "aws_route53_record" "reco-api-test-us-west" {
  zone_id = "${aws_route53_zone.services.zone_id}"
  name    = "api.reco-test-us-west-2"
  type    = "CNAME"
  ttl     = "300"
  records = ["internal-reco-test-283579554.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "reco-api2-test-us-west" {
  zone_id = "${aws_route53_zone.services.zone_id}"
  name    = "api2.reco-test-us-west-2"
  type    = "CNAME"
  ttl     = "300"
  records = ["internal-reco-test2-761256328.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "reco-api-test-us-east" {
  zone_id = "${aws_route53_zone.services.zone_id}"
  name    = "api.reco-test-us-east-1"
  type    = "CNAME"
  ttl     = "300"
  records = ["internal-reco-test-1355130652.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "reco-api-brewprod-us-west" {
  zone_id = "${aws_route53_zone.services.zone_id}"
  name    = "api.reco-brewprod-us-west-2"
  type    = "CNAME"
  ttl     = "300"
  records = ["internal-reco-brewprod-147238334.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "reco-api2-brewprod-us-west" {
  zone_id = "${aws_route53_zone.services.zone_id}"
  name    = "api2.reco-brewprod-us-west-2"
  type    = "CNAME"
  ttl     = "300"
  records = ["internal-reco-brewprod2-45922771.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "reco-api-brewprod-us-east" {
  zone_id = "${aws_route53_zone.services.zone_id}"
  name    = "api.reco-brewprod-us-east-1"
  type    = "CNAME"
  ttl     = "300"
  records = ["internal-us-east-1-jive-reco-brewprod-elb-1548643481.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "reco-api-prod-us-west" {
  zone_id = "${aws_route53_zone.services.zone_id}"
  name    = "api.reco-prod-us-west-2"
  type    = "CNAME"
  ttl     = "300"
  records = ["internal-reco-prod-1657470086.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "reco-api2-prod-us-west" {
  zone_id = "${aws_route53_zone.services.zone_id}"
  name    = "api2.reco-prod-us-west-2"
  type    = "CNAME"
  ttl     = "300"
  records = ["internal-reco-prod2-381187118.us-west-2.elb.amazonaws.com"]
}

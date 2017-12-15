### Route53 hosted zones for JCX cluster ###

resource "aws_route53_zone" "jcx_zone_1" {
  name    = "${var.jcx_zone_1}"
  comment = "Public domain for JCX cluster in ${var.aws_account_short_name}"

  tags {
    Name         = "${var.jcx_zone_1}"
    jive_service = "jcx"
    region       = "${var.region}"
    account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_zone" "jcx_zone_2" {
  name    = "${var.jcx_zone_2}"
  comment = "Public domain for JCX cluster in ${var.aws_account_short_name}"

  tags {
    Name         = "${var.jcx_zone_2}"
    jive_service = "jcx"
    region       = "${var.region}"
    account_name = "${var.aws_account_short_name}"
  }
}

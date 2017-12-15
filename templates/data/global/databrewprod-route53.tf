### Route53 hosted zones for databrewprod cluster ###

resource "aws_route53_zone" "databrewprod_zone_1" {
  name    = "${var.databrewprod_zone_1}"
  comment = "Public domain for databrewprod cluster in ${var.aws_account_short_name}"
  count   = "${var.enable_databrewprod_zone_1}"

  tags {
    Name         = "${var.databrewprod_zone_1}"
    jive_service = "databrewprod"
    region       = "${var.region}"
    account_name = "${var.aws_account_short_name}"
  }
}

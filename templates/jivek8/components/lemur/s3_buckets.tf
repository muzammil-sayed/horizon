resource "aws_s3_bucket" "lemur_certs_log" {
  bucket = "${var.env}-lemur-certs-log-access"
  acl    = "log-delivery-write"

  tags {
    Name              = "${var.env}-lemur-cert-log-access"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
    service_component = "${var.jive_service}"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
  }
}

resource "aws_s3_bucket" "certs_lemur" {
  bucket = "${var.env}-lemur-certs"
  acl    = "private"

  logging {
    target_bucket = "${aws_s3_bucket.lemur_certs_log.id}"
    target_prefix = "log/lemur"
  }

  tags {
    Name              = "${var.env}-lemur-certs"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
    service_component = "${var.jive_service}"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
  }
}

resource "aws_s3_bucket" "lemur_mako_shared_secret" {
  bucket = "${var.env}-lemur-mako-shared-secret"
  acl    = "private"

  tags {
    Name              = "${var.env}-lemur-mako-shared-secret"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
    service_component = "${var.jive_service}"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
  }
}

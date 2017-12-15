data "template_file" "s3_policy" {
  template = "${file("s3_policy_template.tpl")}"

  vars {
    aws_account     = "${var.aws_account_id}"
    pipeline_phase  = "${var.env}"
    jive_subservice = "${var.jive_subservice}"
    region          = "${var.region}"
  }
}

resource "aws_s3_bucket" "snapshot_bucket" {
  bucket = "${var.region}-jive-data-${var.env}-${var.jive_subservice}-snaps"
  acl    = "private"
  policy = "${data.template_file.s3_policy.rendered}"

  tags {
    Name               = "${var.env}-${var.jive_subservice}-elasticsearch-snapshots"
    pipeline_phase     = "${var.env}"
    service_component  = "elasticsearch_snapshots"
    jive_service       = "${var.jive_service}"
    jive_subservice    = "${var.jive_subservice}"
    sla                = "${var.sla}"
  }
}

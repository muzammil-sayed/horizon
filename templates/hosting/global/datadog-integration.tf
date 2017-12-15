resource "aws_iam_role" "datadog-ro" {
  name               = "datadog-ro"
  assume_role_policy = "${file("datadog/assume-role.${var.aws_account_short_name}.policy")}"
}

resource "aws_iam_policy" "datadog_ro" {
  name   = "datadog_ro"
  policy = "${file("datadog/datadog-ro.policy")}"
}

resource "aws_iam_policy" "datadog_cloudtrail_ro" {
  name   = "datadog_cloudtrail_ro"
  policy = "${data.template_file.datadog_cloudtrail_ro.rendered}"
}

data "template_file" "datadog_cloudtrail_ro" {
  template = "${file("datadog/cloudtrail-ro.policy.template")}"

  vars {
    cloudtrail_bucket_arn = "${aws_s3_bucket.cloudtrail.arn}"
  }
}

resource "aws_iam_policy_attachment" "datadog_ro" {
  name = "datadog_ro"

  roles = [
    "${aws_iam_role.datadog-ro.name}",
  ]

  policy_arn = "${aws_iam_policy.datadog_ro.arn}"
}

resource "aws_iam_policy_attachment" "datadog_cloudtrail_ro" {
  name = "datadog_cloudtrail_ro"

  roles = [
    "${aws_iam_role.datadog-ro.name}",
  ]

  policy_arn = "${aws_iam_policy.datadog_cloudtrail_ro.arn}"
}

resource "aws_iam_role" "datadog-ro" {
  name               = "datadog-ro"
  assume_role_policy = "${file("datadog/assume-role.${var.aws_account_short_name}.policy")}"
}

resource "aws_iam_policy" "datadog_ro" {
  name   = "datadog_ro"
  policy = "${file("datadog/datadog-ro.policy")}"
}

resource "aws_iam_policy_attachment" "datadog_ro" {
  name = "datadog_ro"

  roles = [
    "${aws_iam_role.datadog-ro.name}",
  ]

  policy_arn = "${aws_iam_policy.datadog_ro.arn}"
}

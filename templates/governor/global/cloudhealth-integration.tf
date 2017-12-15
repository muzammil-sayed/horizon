resource "aws_iam_role" "cloudhealth-ro" {
  name               = "cloudhealth-ro"
  assume_role_policy = "${file("cloudhealth/assume-role.policy")}"
}

resource "aws_iam_policy" "cloudhealth_ro" {
  name   = "cloudhealth_ro"
  policy = "${file("cloudhealth/cloudhealth-ro.policy")}"
}

resource "aws_iam_policy_attachment" "cloudhealth_ro" {
  name = "cloudhealth_ro"

  roles = [
    "${aws_iam_role.cloudhealth-ro.name}",
  ]

  policy_arn = "${aws_iam_policy.cloudhealth_ro.arn}"
}

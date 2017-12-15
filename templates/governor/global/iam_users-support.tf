resource "aws_iam_group" "support" {
  name = "support"
}

resource "aws_iam_group_policy" "support_policy" {
  name   = "support_policy"
  group  = "${aws_iam_group.support.name}"
  policy = "${file("access_keys.policy")}"
}

resource "aws_iam_group_membership" "support" {
  name = "support"

  users = [
    "${aws_iam_user.rick_valdez.name}",
  ]

  group = "${aws_iam_group.support.name}"
}

resource "aws_iam_user" "rick_valdez" {
  name = "rick.valdez"
}

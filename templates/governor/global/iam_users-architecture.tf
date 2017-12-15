resource "aws_iam_group" "architecture" {
  name = "architecture"
}

resource "aws_iam_group_policy" "architecture_policy" {
  name   = "architecture_policy"
  group  = "${aws_iam_group.architecture.name}"
  policy = "${file("access_keys.policy")}"
}

resource "aws_iam_group_membership" "architecture" {
  name = "architecture"

  users = [
    "${aws_iam_user.david_brown.name}",
  ]

  group = "${aws_iam_group.architecture.name}"
}

resource "aws_iam_user" "david_brown" {
  name = "david.brown"
}

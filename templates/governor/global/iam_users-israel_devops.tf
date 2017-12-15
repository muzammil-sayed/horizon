resource "aws_iam_group" "israel_devops" {
  name = "israel_devops"
}

resource "aws_iam_group_policy" "israel_devops_policy" {
  name   = "israel_devops_policy"
  group  = "${aws_iam_group.israel_devops.name}"
  policy = "${file("access_keys.policy")}"
}

resource "aws_iam_group_membership" "israel_devops" {
  name = "israel_devops_membership"

  users = [
    "${aws_iam_user.niv_basson.name}",
  ]

  group = "${aws_iam_group.israel_devops.name}"
}

resource "aws_iam_user" "niv_basson" {
  name = "niv.basson"
}

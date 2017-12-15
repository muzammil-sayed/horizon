resource "aws_iam_group" "TEAM" {
  name = "TEAM"
}

resource "aws_iam_group_policy" "TEAM_policy" {
  name   = "TEAM_policy"
  group  = "${aws_iam_group.TEAM.name}"
  policy = "${file("access_keys.policy")}"
}

resource "aws_iam_group_membership" "TEAM" {
  name = "TEAM_membership"

  users = [
    "${aws_iam_user.FIRST_LAST.name}",
  ]

  group = "${aws_iam_group.TEAM.name}"
}

resource "aws_iam_user" "FIRST_LAST" {
  name = "FIRST.LAST"
}

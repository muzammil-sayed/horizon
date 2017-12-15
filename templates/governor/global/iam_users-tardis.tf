resource "aws_iam_group" "tardis" {
  name = "tardis"
}

resource "aws_iam_group_policy" "tardis_policy" {
  name   = "tardis_policy"
  group  = "${aws_iam_group.tardis.name}"
  policy = "${file("access_keys.policy")}"
}

resource "aws_iam_group_membership" "tardis" {
  name = "tardis"

  users = [
    "${aws_iam_user.michael_lilley.name}",
    "${aws_iam_user.larry_peterson.name}",
  ]

  group = "${aws_iam_group.tardis.name}"
}

# will need to move taylor_thornton and michael_lilley 's resources from
# their existing iam_users-*.tf files into this one when they
# move off other teams.

resource "aws_iam_user" "larry_peterson" {
  name = "larry.peterson"
}

resource "aws_iam_group" "baas" {
  name = "baas"
}

resource "aws_iam_group_policy" "baas_policy" {
  name   = "baas_policy"
  group  = "${aws_iam_group.baas.name}"
  policy = "${file("access_keys.policy")}"
}

resource "aws_iam_group_membership" "baas" {
  name = "baas"

  users = [
  ]

  group = "${aws_iam_group.baas.name}"
}

# will need to move taylor_thornton and michael_lilley 's resources from
# their existing iam_users-*.tf files into this one when they
# move off other teams.


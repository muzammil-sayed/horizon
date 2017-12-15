# Note: this is the container group for both IAAS and PLOPS teams. At some

# point in the future we should break PLOPS out into a separate group...but

# not today.

resource "aws_iam_group" "iaas" {
  name = "iaas"
}

resource "aws_iam_group_policy" "iaas_policy" {
  name   = "iaas_policy"
  group  = "${aws_iam_group.iaas.name}"
  policy = "${file("access_keys.policy")}"
}

resource "aws_iam_group_membership" "iaas" {
  name = "iaas_membership"

  users = [
    "${aws_iam_user.david_sundberg.name}",
    "${aws_iam_user.devon_peters.name}",
    "${aws_iam_user.shaun_kasperowicz.name}",
    "${aws_iam_user.peter_auv.name}",
    "${aws_iam_user.don_forbes.name}",
    "${aws_iam_user.shimran_george.name}",
    "${aws_iam_user.sylvester_mitchell.name}",
  ]

  group = "${aws_iam_group.iaas.name}"
}

resource "aws_iam_user" "david_sundberg" {
  name = "david.sundberg"
}

resource "aws_iam_user" "devon_peters" {
  name = "devon.peters"
}

resource "aws_iam_user" "shaun_kasperowicz" {
  name = "shaun.kasperowicz"
}

resource "aws_iam_user" "peter_auv" {
  name = "peter.auv"
}

resource "aws_iam_user" "don_forbes" {
  name = "don.forbes"
}

resource "aws_iam_user" "sylvester_mitchell" {
  name = "sylvester.mitchell"
}

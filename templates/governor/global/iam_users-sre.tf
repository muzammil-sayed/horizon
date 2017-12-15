resource "aws_iam_group" "sre" {
  name = "sre"
}

resource "aws_iam_group_policy" "sre_policy" {
  name   = "sre_policy"
  group  = "${aws_iam_group.sre.name}"
  policy = "${file("access_keys.policy")}"
}

resource "aws_iam_group_membership" "sre" {
  name = "sre_membership"

  users = [
    "${aws_iam_user.frank_davalos.name}",
    "${aws_iam_user.david_throckmorton.name}",
    "${aws_iam_user.paul_wroe.name}",
    "${aws_iam_user.adam_luckey.name}",
  ]

  group = "${aws_iam_group.sre.name}"
}

resource "aws_iam_group" "sre-pipeline-roles" {
  name = "sre-pipeline-roles"
}

resource "aws_iam_group_policy" "sre-pipeline-roles" {
  name  = "sre-pipeline-roles"
  group = "${aws_iam_group.sre-pipeline-roles.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::811034720611:role/mako*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group_membership" "sre-pipeline-roles" {
  name = "sre-pipeline-roles-membership"

  users = [
    "${aws_iam_user.frank_davalos.name}",
    "${aws_iam_user.david_throckmorton.name}",
    "${aws_iam_user.paul_wroe.name}",
    "${aws_iam_user.adam_luckey.name}",
  ]

  group = "${aws_iam_group.sre-pipeline-roles.name}"
}

resource "aws_iam_user" "frank_davalos" {
  name = "frank.davalos"
}

resource "aws_iam_user" "david_throckmorton" {
  name = "david.throckmorton"
}

resource "aws_iam_user" "paul_wroe" {
  name = "paul.wroe"
}

resource "aws_iam_user" "adam_luckey" {
  name = "adam.luckey"
}

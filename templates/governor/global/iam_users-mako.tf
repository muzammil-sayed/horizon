resource "aws_iam_group" "mako" {
  name = "mako"
}

resource "aws_iam_group_policy" "mako_policy" {
  name   = "mako_policy"
  group  = "${aws_iam_group.mako.name}"
  policy = "${file("access_keys.policy")}"
}

resource "aws_iam_group_membership" "mako" {
  name = "mako_membership"

  users = [
    "${aws_iam_user.bruce_downs.name}", # NOTE: BRUCE'S USER IS DEFINED IN iam_users-reco.tf
    "${aws_iam_user.andras_liter.name}",
]

  group = "${aws_iam_group.mako.name}"
}

resource "aws_iam_group" "mako-pipeline-roles" {
  name = "mako-pipeline-roles"
}
resource "aws_iam_user" "andras_liter" {
  name = "andras.liter"
}

resource "aws_iam_group_policy" "mako-pipeline-roles" {
  name  = "mako-pipeline-roles"
  group = "${aws_iam_group.mako-pipeline-roles.id}"

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

resource "aws_iam_group_membership" "mako-pipeline-roles" {
  name = "mako-pipeline-roles-membership"

  users = [
  ]

  group = "${aws_iam_group.mako-pipeline-roles.name}"
}

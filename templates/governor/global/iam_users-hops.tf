resource "aws_iam_group" "hops" {
  name = "hops"
}

resource "aws_iam_group_policy" "hops_policy" {
  name   = "hops_policy"
  group  = "${aws_iam_group.hops.name}"
  policy = "${file("access_keys.policy")}"
}

resource "aws_iam_group_membership" "hops" {
  name = "hops_membership"

  users = [
    "${aws_iam_user.shimran_george.name}",
  ]

  group = "${aws_iam_group.hops.name}"
}

resource "aws_iam_group" "hops-pipeline-roles" {
  name = "hops-pipeline-roles"
}

resource "aws_iam_group_policy" "hops-pipeline-roles" {
  name  = "hops-pipeline-roles"
  group = "${aws_iam_group.hops-pipeline-roles.id}"

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

resource "aws_iam_group_membership" "hops-pipeline-roles" {
  name = "hops-pipeline-roles-membership"

  users = [
    "${aws_iam_user.shimran_george.name}",
  ]

  group = "${aws_iam_group.hops-pipeline-roles.name}"
}

resource "aws_iam_user" "shimran_george" {
  name = "shimran.george"
}

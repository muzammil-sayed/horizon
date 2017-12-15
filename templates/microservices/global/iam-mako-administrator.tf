resource "aws_iam_role" "mako-administrator" {
  name = "mako-administrator"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.governor_account_arn}"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role" "okta-mako" {
  name               = "okta-mako"
  assume_role_policy = "${data.template_file.okta-assumerole.rendered}"
}

resource "aws_iam_policy" "mako-administrator" {
  name = "mako-administrator"

  policy = "${data.template_file.mako-administrator-policy.rendered}"
}

data "template_file" "mako-administrator-policy" {
  template = "${file("team.policy.template")}"

  vars {
    resource_prefix = "mako"
  }
}

resource "aws_iam_policy_attachment" "mako-administrator" {
  name = "mako-administrator"

  roles = [
    "${aws_iam_role.mako-administrator.name}",
    "${aws_iam_role.okta-mako.name}",
  ]

  policy_arn = "${aws_iam_policy.mako-administrator.arn}"
}

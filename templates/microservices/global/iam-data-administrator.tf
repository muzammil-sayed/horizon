resource "aws_iam_role" "data-administrator" {
  name = "data-administrator"

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

resource "aws_iam_role" "okta-data" {
  name               = "okta-data"
  assume_role_policy = "${data.template_file.okta-assumerole.rendered}"
}

resource "aws_iam_policy" "data-administrator" {
  name = "data-administrator"

  policy = "${data.template_file.data-administrator-policy.rendered}"
}

data "template_file" "data-administrator-policy" {
  template = "${file("team.policy.template")}"

  vars {
    resource_prefix = "data"
  }
}

resource "aws_iam_policy_attachment" "data-administrator" {
  name = "data-administrator"

  roles = [
    "${aws_iam_role.data-administrator.name}",
    "${aws_iam_role.okta-data.name}",
  ]

  policy_arn = "${aws_iam_policy.data-administrator.arn}"
}

resource "aws_iam_role" "israel-administrator" {
  name = "israel-administrator"

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

resource "aws_iam_role" "okta-israel" {
  name               = "okta-israel"
  assume_role_policy = "${data.template_file.okta-assumerole.rendered}"
}

resource "aws_iam_policy" "israel-administrator" {
  name = "israel-administrator"

  policy = "${data.template_file.israel-administrator-policy.rendered}"
}

data "template_file" "israel-administrator-policy" {
  template = "${file("team.policy.template")}"

  vars {
    resource_prefix = "soa"
  }
}

resource "aws_iam_policy_attachment" "israel-administrator" {
  name = "israel-administrator"

  roles = [
    "${aws_iam_role.israel-administrator.name}",
    "${aws_iam_role.okta-israel.name}",
  ]

  policy_arn = "${aws_iam_policy.israel-administrator.arn}"
}

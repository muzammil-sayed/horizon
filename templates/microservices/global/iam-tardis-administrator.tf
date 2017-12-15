resource "aws_iam_role" "tardis-administrator" {
  name = "tardis-administrator"

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

resource "aws_iam_role" "okta-tardis" {
  name               = "okta-tardis"
  assume_role_policy = "${data.template_file.okta-assumerole.rendered}"
}

# Policy for resources with a 'tardis' prefix
resource "aws_iam_policy" "tardis-administrator" {
  name = "tardis-administrator"

  policy = "${data.template_file.tardis-administrator-policy.rendered}"
}

data "template_file" "tardis-administrator-policy" {
  template = "${file("team.policy.template")}"

  vars {
    resource_prefix = "tardis"
  }
}

resource "aws_iam_policy_attachment" "tardis-administrator" {
  name = "tardis-administrator"

  roles = [
    "${aws_iam_role.tardis-administrator.name}",
    "${aws_iam_role.okta-tardis.name}",
  ]

  policy_arn = "${aws_iam_policy.tardis-administrator.arn}"
}

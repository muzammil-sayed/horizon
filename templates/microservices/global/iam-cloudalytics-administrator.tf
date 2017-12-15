resource "aws_iam_role" "cloudalytics-administrator" {
  name = "cloudalytics-administrator"

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

resource "aws_iam_role" "okta-cloudalytics" {
  name               = "okta-cloudalytics"
  assume_role_policy = "${data.template_file.okta-assumerole.rendered}"
}

# Policy for resources with a 'cloudalytics' prefix
resource "aws_iam_policy" "cloudalytics-administrator" {
  name = "cloudalytics-administrator"

  policy = "${data.template_file.cloudalytics-administrator-policy.rendered}"
}

data "template_file" "cloudalytics-administrator-policy" {
  template = "${file("team.policy.template")}"

  vars {
    resource_prefix = "cloudalytics"
  }
}

resource "aws_iam_policy_attachment" "cloudalytics-administrator" {
  name = "cloudalytics-administrator"

  roles = [
    "${aws_iam_role.cloudalytics-administrator.name}",
    "${aws_iam_role.okta-cloudalytics.name}",
  ]

  policy_arn = "${aws_iam_policy.cloudalytics-administrator.arn}"
}

# Policy for resources with a 'ca-' prefix
resource "aws_iam_policy" "ca-administrator" {
  name = "ca-administrator"

  policy = "${data.template_file.ca-administrator-policy.rendered}"
}

data "template_file" "ca-administrator-policy" {
  template = "${file("team.policy.template")}"

  vars {
    resource_prefix = "ca-"
  }
}

resource "aws_iam_policy_attachment" "ca-administrator" {
  name = "ca-administrator"

  roles = [
    "${aws_iam_role.cloudalytics-administrator.name}",
    "${aws_iam_role.okta-cloudalytics.name}",
  ]

  policy_arn = "${aws_iam_policy.ca-administrator.arn}"
}

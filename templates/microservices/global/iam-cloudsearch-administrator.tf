resource "aws_iam_role" "cloudsearch-administrator" {
  name = "cloudsearch-administrator"

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

resource "aws_iam_role" "okta-cloudsearch" {
  name               = "okta-cloudsearch"
  assume_role_policy = "${data.template_file.okta-assumerole.rendered}"
}

# policy for resources with a 'cloudsearch' prefix
resource "aws_iam_policy" "cloudsearch-administrator" {
  name = "cloudsearch-administrator"

  policy = "${data.template_file.cloudsearch-administrator-policy.rendered}"
}

data "template_file" "cloudsearch-administrator-policy" {
  template = "${file("team.policy.template")}"

  vars {
    resource_prefix = "cloudsearch"
  }
}

resource "aws_iam_policy_attachment" "cloudsearch-administrator" {
  name = "cloudsearch-administrator"

  roles = [
    "${aws_iam_role.cloudsearch-administrator.name}",
    "${aws_iam_role.okta-cloudsearch.name}",
  ]

  policy_arn = "${aws_iam_policy.cloudsearch-administrator.arn}"
}

# policy for resources with a 'search' prefix
resource "aws_iam_policy" "search-administrator" {
  name = "search-administrator"

  policy = "${data.template_file.search-administrator-policy.rendered}"
}

data "template_file" "search-administrator-policy" {
  template = "${file("team.policy.template")}"

  vars {
    resource_prefix = "search"
  }
}

resource "aws_iam_policy_attachment" "search-administrator" {
  name = "search-administrator"

  roles = [
    "${aws_iam_role.cloudsearch-administrator.name}",
    "${aws_iam_role.okta-cloudsearch.name}",
  ]

  policy_arn = "${aws_iam_policy.search-administrator.arn}"
}

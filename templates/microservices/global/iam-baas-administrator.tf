resource "aws_iam_role" "baas-administrator" {
  name = "baas-administrator"

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

resource "aws_iam_role" "okta-baas" {
  name               = "okta-baas"
  assume_role_policy = "${data.template_file.okta-assumerole.rendered}"
}

# Policy for resources with a 'baas' prefix
resource "aws_iam_policy" "baas-administrator" {
  name = "baas-administrator"

  policy = "${data.template_file.baas-administrator-policy.rendered}"
}

data "template_file" "baas-administrator-policy" {
  template = "${file("team.policy.template")}"

  vars {
    resource_prefix = "baas"
  }
}

resource "aws_iam_policy_attachment" "baas-administrator" {
  name = "baas-administrator"

  roles = [
    "${aws_iam_role.baas-administrator.name}",
    "${aws_iam_role.okta-baas.name}",
  ]

  policy_arn = "${aws_iam_policy.baas-administrator.arn}"
}

resource "aws_iam_user" "mako-iam-integration" {
  name = "mako-iam-integration"
}

resource "aws_iam_policy_attachment" "mako-iam-integration" {
  name       = "mako-iam-integration"
  users      = ["${aws_iam_user.mako-iam-integration.name}"]
  policy_arn = "${aws_iam_policy.mako-iam-update-policy.arn}"
}

resource "aws_iam_policy" "mako-iam-update-policy" {
  name        = "mako-iam-update-policy"
  description = "Policy for mako-iam-integration user to manage mako service users."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateUser",
                "iam:GetUser",
                "iam:CreateAccessKey",
                "iam:DeleteAccessKey",
                "iam:ListAccessKeys",
                "iam:PutUserPolicy"
            ],
            "Resource": "arn:aws:iam::${var.aws_account_id}:user/mako*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateRole",
                "iam:GetRole",
                "iam:PutRolePolicy"
            ],
            "Resource": "arn:aws:iam::${var.aws_account_id}:role/mako*"
        }
    ]
}
EOF
}

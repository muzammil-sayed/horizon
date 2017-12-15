resource "aws_iam_user" "plops-mako-key-refresh" {
  name = "plops-mako-key-refresh"
}

resource "aws_iam_policy_attachment" "plops_mako_key_refresh_policy_attachment" {
  name       = "plops-mako-key-refresh-policy-attachment"
  users      = ["${aws_iam_user.plops-mako-key-refresh.name}"]
  policy_arn = "${aws_iam_policy.plops_mako_key_refresh_policy.arn}"
}

resource "aws_iam_policy" "plops_mako_key_refresh_policy" {
    name = "plops-mako-key-refresh-policy"
    description = "PLOPS service user policy to allow updating of access and secret keys for MAKO service users"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PlopsMakoKeyRefreshPolicy",
            "Effect": "Allow",
            "Action": [
                "iam:CreateAccessKey",
                "iam:DeleteAccessKey",
                "iam:GetAccessKeyLastUsed",
                "iam:ListAccessKeys",
                "iam:UpdateAccessKey"
            ],
            "Resource": [
              "arn:aws:iam::${var.aws_account_id}:user/mako-route53",
              "arn:aws:iam::${var.aws_account_id}:user/mako-iam-integration"
            ]
        }
    ]
}
EOF
}

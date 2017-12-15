resource "aws_iam_role_policy" "asg-monitor" {
  name = "${var.region}_${var.aws_account_short_name}-asg-monitor-policy"
  role = "${aws_iam_role.asg-monitor.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

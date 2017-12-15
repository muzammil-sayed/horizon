# The Infra account has extra S3 privileges for handling Datadog monitors.

resource "aws_iam_user" "datadog_monitors" {
  name = "datadog-monitors"
}

resource "aws_iam_policy_attachment" "datadog_monitors_policy_attachment" {
  name       = "datadog-monitors-policy-attachment"
  users      = ["${aws_iam_user.datadog_monitors.name}"]
  policy_arn = "${aws_iam_policy.datadog_monitors_policy.arn}"
}

resource "aws_iam_policy" "datadog_monitors_policy" {
    name = "datadog-monitors-policy"
    description = "Datadog Monitors policy to allow S3 access"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DatadogMonitorsPolicy",
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObject"
            ],
	    "Resource":[
		"arn:aws:s3:::jive-datadog-${var.aws_account_short_name}-usw2",
		"arn:aws:s3:::jive-datadog-${var.aws_account_short_name}-usw2/*"
	    ]
        }
    ]
}
EOF
}

# The ms-prod account has full S3 privileges on "ca-" prefixed buckets.

resource "aws_iam_user" "ca-data-migration" {
  name = "ca-data-migration"
}

resource "aws_iam_policy_attachment" "ca-data-migration_policy_attachment" {
  name       = "ca-data-migration-policy-attachment"
  users      = ["${aws_iam_user.ca-data-migration.name}"]
  policy_arn = "${aws_iam_policy.ca-data-migration_policy.arn}"
}

resource "aws_iam_policy" "ca-data-migration_policy" {
  name        = "ca-data-migration-policy"
  description = "Cloudalytics data migration policy to allow S3 access"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CADataMigrationPolicy",
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObject"
            ],
	    "Resource":[
		"arn:aws:s3:::ca-*",
		"arn:aws:s3:::ca-*/*"
	    ]
        }
    ]
}
EOF
}

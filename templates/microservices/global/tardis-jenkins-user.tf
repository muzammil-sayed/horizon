resource "aws_iam_user" "tardis-jenkins" {
  name = "tardis-jenkins"
}

resource "aws_iam_policy_attachment" "tardis-jenkins_policy_attachment" {
  name       = "tardis-jenkins-policy-attachment"
  users      = ["${aws_iam_user.tardis-jenkins.name}"]
  policy_arn = "${aws_iam_policy.tardis-jenkins_policy.arn}"
}

resource "aws_iam_policy" "tardis-jenkins_policy" {
  name        = "tardis-jenkins-policy"
  description = "Tardis Jenkins policy to only object upload (write) to S3 buckets prefixed with tardis."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Sid": "AllowListingOfAllBuckets",
          "Effect": "Allow",
          "Action": "s3:ListAllMyBuckets",
          "Resource": "*"
        },
        {
          "Sid": "AllowPutObjectOfOnlyTardisBuckets",
          "Effect": "Allow",
          "Action":  "s3:*",
          "Resource": [
            "arn:aws:s3:::tardis*",
            "arn:aws:s3:::tardis*/*"
          ]
        }
    ]
}
EOF
}

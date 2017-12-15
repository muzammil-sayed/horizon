resource "aws_iam_user" "jcx-jenkins" {
  name = "jcx-jenkins"
}

resource "aws_iam_policy_attachment" "jcx-jenkins_policy_attachment" {
  name       = "jcx-jenkins-policy-attachment"
  users      = ["${aws_iam_user.jcx-jenkins.name}"]
  policy_arn = "${aws_iam_policy.jcx-jenkins-release_policy.arn}"
}

resource "aws_iam_policy" "jcx-jenkins-release_policy" {
    name = "jcx-jenkins-release-policy"
    description = "JCX Jenkins policy to only allow management of S3 buckets prefixed with jcx-release."
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
          "Sid": "AllowManagementOfOnlyJcxReleaseBuckets",
          "Effect": "Allow",
          "Action": "s3:*",
          "Resource": [
            "arn:aws:s3:::jcx-release*",
            "arn:aws:s3:::jcx-release*/*"
          ]
        }
    ]
}
EOF
}

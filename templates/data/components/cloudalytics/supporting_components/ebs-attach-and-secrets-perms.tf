resource "aws_iam_role" "ebs-attach-and-secrets" {
  name = "ebs-attach-and-secrets-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ebs-attach-and-secrets" {
  name  = "ebs-attach-and-secrets-profile"
  roles = ["${aws_iam_role.ebs-attach-and-secrets.name}"]
}

resource "aws_iam_role_policy" "ebs-attach-and-secrets" {
  name = "ebs-attach-and-secrets-policy"
  role = "${aws_iam_role.ebs-attach-and-secrets.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
              "Effect": "Allow",
              "Action": [
                "ec2:AttachVolume",
                "ec2:CreateTags",
                "ec2:Describe*",
                "ec2:DetachVolume",
                "elasticache:Describe*",
                "rds:Describe*",
                "route53:ListHostedZones",
                "route53:ListResourceRecordSets",
                "s3:ListAllMyBuckets"
              ],
              "Resource": "*"
        },
        {
              "Effect": "Allow",
              "Action": [
                  "s3:GetBucketLocation",
                  "s3:GetObject",
                  "s3:ListBucket"
              ],
              "Resource": [
                  "arn:aws:s3:::${var.region}-jive-data-${var.env}-secrets",
                  "arn:aws:s3:::${var.region}-jive-data-${var.env}-secrets/*",
                  "arn:aws:s3:::us-west-2-jive-data-pipeline-playbooks",
                  "arn:aws:s3:::us-west-2-jive-data-pipeline-playbooks/*"
              ]
        }
    ]
}
EOF
}

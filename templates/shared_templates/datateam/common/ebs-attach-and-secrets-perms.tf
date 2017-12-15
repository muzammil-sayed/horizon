resource "aws_iam_role" "ebs-attach-and-secrets" {
  name = "${var.region}-ebs-attach-and-secrets-role-${var.jive_subservice}"

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
  name = "${var.region}-ebs-attach-and-secrets-profile-${var.jive_subservice}"
  role = "${aws_iam_role.ebs-attach-and-secrets.name}"
}

resource "aws_iam_role_policy" "ebs-attach-and-secrets" {
  name = "${var.region}-ebs-attach-and-secrets-policy-${var.jive_subservice}"
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
                "route53:ListResourceRecordSets"
              ],
              "Resource": "*"
        },
        {
              "Effect": "Allow",
              "Action": [
                  "s3:GetBucketLocation",
                  "s3:ListBucket"
              ],
              "Resource": [
                  "arn:aws:s3:::${var.region}-jive-data-${var.env}-secrets",
                  "arn:aws:s3:::us-west-2-jive-data-pipeline-playbooks"
              ]
        },
        {
              "Effect": "Allow",
              "Action": [
                  "s3:DeleteObject",
                  "s3:GetObject",
                  "s3:PutObject"
              ],
              "Resource": [
                  "arn:aws:s3:::${var.region}-jive-data-${var.env}-secrets/*",
                  "arn:aws:s3:::us-west-2-jive-data-pipeline-playbooks/*"
              ]
        }
    ]
}
EOF
}

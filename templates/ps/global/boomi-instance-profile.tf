resource "aws_iam_instance_profile" "boomi-node" {
  name = "boomi-node"

  roles = ["${aws_iam_role.boomi-node.name}"]
}

resource "aws_iam_role" "boomi-node" {
  name = "boomi-node"

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

resource "aws_iam_role_policy" "boomi-node" {
  name = "boomi-node"
  role = "${aws_iam_role.boomi-node.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
              "Effect": "Allow",
              "Action": [
                "ec2:Describe*",
                "route53:ListHostedZones",
                "route53:ListResourceRecordSets",
                "rds:Describe*",
                "elasticache:Describe*",
                "s3:GetObject",
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "ec2:AttachVolume",
                "ec2:DetachVolume",
                "ec2:CopySnapshot",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot",
                "ec2:DescribeSnapshots",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DescribeTags"
              ],
              "Resource": "*"
        }
    ]
}
EOF
}

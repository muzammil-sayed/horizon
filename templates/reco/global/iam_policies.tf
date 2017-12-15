resource "aws_iam_role_policy" "ansible" {
  name = "ansible-policy"
  role = "${aws_iam_role.ansible.id}"

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
                "s3:ListBucket"
              ],
              "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "upena" {
  name = "upena-policy"
  role = "${aws_iam_role.upena.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
              "Effect": "Allow",
              "Action": [
                "ec2:*",
                "route53:*",
                "s3:*",
                "elasticloadbalancing:*"
              ],
              "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "eni-attach" {
  name = "eni-attach-policy"
  role = "${aws_iam_role.eni-attach.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
              "Effect": "Allow",
              "Action": [
                "ec2:Describe*",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "route53:ListHostedZones",
                "route53:ListResourceRecordSets",
                "rds:Describe*",
                "elasticache:Describe*",
                "s3:GetObject",
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "ec2:AttachNetworkInterface"
              ],
              "Resource": "*"
        }
    ]
}
EOF
}

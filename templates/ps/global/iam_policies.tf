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

resource "aws_iam_policy" "ps-server-cert" {
  name        = "ps-server-cert-policy"
  description = "IAM Server Certificate management for PS"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
              "Effect": "Allow",
              "Action": [
                "iam:DeleteServerCertificate",
                "iam:DeleteSigningCertificate",
                "iam:GetServerCertificate",
                "iam:ListServerCertificates",
                "iam:ListSigningCertificates",
                "iam:UpdateServerCertificate",
                "iam:UpdateSigningCertificate",
                "iam:UploadServerCertificate",
                "iam:UploadSigningCertificate"
              ],
              "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ps-instance-profiles" {
  name        = "ps-instance-profiles-policy"
  description = "IAM instance-profile assignement capabilities for PS"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
              "Effect": "Allow",
              "Action": "iam:PassRole",
              "Resource": [
                  "${aws_iam_role.ansible.arn}",
                  "${aws_iam_role.eni-attach.arn}",
                  "${aws_iam_role.boomi-node.arn}"
              ]
        }
    ]
}
EOF
}

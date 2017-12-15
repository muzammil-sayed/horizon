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

resource "aws_iam_role_policy" "lemur_policy" {
  name = "route53"
  role = "${aws_iam_role.lemur_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:GetChange",
                "route53:GetChangeDetails",
                "route53:ListHostedZones"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "route53:ChangeResourceRecordSets",
            "Resource": "arn:aws:route53:::hostedzone/${aws_route53_zone.services.zone_id}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "reco-route53" {
  name = "reco-route53"
  role = "${aws_iam_role.reco-administrator.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:GetChange",
                "route53:GetChangeDetails",
                "route53:ListHostedZones"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "route53:ChangeResourceRecordSets",
            "Resource": "arn:aws:route53:::hostedzone/${aws_route53_zone.services.zone_id}"
        }
    ]
}
EOF
}

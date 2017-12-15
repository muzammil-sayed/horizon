resource "aws_iam_role_policy" "k8s-master" {
  name = "${null_resource.k8s_cluster.triggers.name}-master-policy"
  role = "${aws_iam_role.k8s-master.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["ec2:*"],
            "Resource": ["*"]
        },
        {
            "Effect": "Allow",
            "Action": ["elasticloadbalancing:*"],
            "Resource": ["*"]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*",
                "ec2:AttachVolume",
                "ec2:DetachVolume",
                "route53:ListHostedZones",
                "route53:ListResourceRecordSets",
                "rds:Describe*",
                "elasticache:Describe*",
                "s3:GetObject",
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "k8s-node" {
  name = "${null_resource.k8s_cluster.triggers.name}-node-policy"
  role = "${aws_iam_role.k8s-node.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*",
                "ec2:AttachVolume",
                "ec2:DetachVolume",
                "ec2:AttachNetworkInterface",
                "ec2:DetachNetworkInterface",
                "route53:ListHostedZones",
                "route53:ListResourceRecordSets",
                "rds:Describe*",
                "elasticache:Describe*",
                "s3:GetObject",
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "s3:PutObject",
                "s3:CreateBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

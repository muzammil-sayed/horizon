resource "aws_iam_role_policy" "lemur_policy" {
  name = "${var.env}-lemur-policy"
  role = "${aws_iam_role.lemur_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds:DescribeAccountAttributes",
        "rds:DescribeDBClusterParameters",
        "rds:DescribeDBClusters",
        "rds:DescribeDBInstances"
      ],
      "Resource": ["arn:aws:rds:*:*:db:*lemur*"]
    },
    {
       "Effect": "Allow",
       "Action": ["ec2:AttachVolume"],
       "Resource": [
          "arn:aws:ec2:*:*:instance/*",
          "arn:aws:ec2:*:*:volume/${aws_ebs_volume.lemur_ebs.id}"
       ]
    },
    {
       "Effect": "Allow",
       "Action": ["ec2:Describe*"],
       "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "S3:PutObject",
        "S3:PutObjectAcl"
      ],
      "Resource": [
        "${aws_s3_bucket.lemur_mako_shared_secret.arn}/*",
        "arn:aws:s3:::us-west-2-jive-jcx-prod-master/*",
        "arn:aws:s3:::us-west-2-jive-jcx-prod-node/*",
        "arn:aws:s3:::us-west-2-jive-jcx-prod-etcd/*",
        "arn:aws:s3:::us-west-2-jive-microservices-brewprod-master/*",
        "arn:aws:s3:::us-west-2-jive-microservices-brewprod-node/*",
        "arn:aws:s3:::us-west-2-jive-microservices-brewprod-etcd/*",
        "arn:aws:s3:::us-west-2-jive-microservices-prod-master/*",
        "arn:aws:s3:::us-west-2-jive-microservices-prod-node/*",
        "arn:aws:s3:::us-west-2-jive-microservices-prod-etcd/*",
        "arn:aws:s3:::us-west-2-jive-microservices-prod-jcx-master/*",
        "arn:aws:s3:::us-west-2-jive-microservices-prod-jcx-node/*",
        "arn:aws:s3:::us-west-2-jive-microservices-prod-jcx-etcd/*",
        "arn:aws:s3:::us-east-1-jive-microservices-prod-master/*",
        "arn:aws:s3:::us-east-1-jive-microservices-prod-node/*",
        "arn:aws:s3:::us-east-1-jive-microservices-prod-etcd/*",
        "arn:aws:s3:::us-east-1-jive-microservices-prod-jcx-master/*",
        "arn:aws:s3:::us-east-1-jive-microservices-prod-jcx-node/*",
        "arn:aws:s3:::us-east-1-jive-microservices-prod-jcx-etcd/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "${aws_s3_bucket.certs_lemur.arn}/*",
        "${aws_s3_bucket.lemur_mako_shared_secret.arn}/*",
        "arn:aws:s3:::jive-ansible-coreos-vault-jive-infra-prod-usw2/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:GetChange",
        "route53:GetChangeDetails",
        "route53:ListHostedZones"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::*:role/Lemur"
    }
  ]
}
EOF
}

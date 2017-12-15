resource "aws_iam_user" "cloudability_billing" {
  name = "cloudability-billing"
}

resource "aws_iam_policy_attachment" "cloudability_billing" {
  name       = "cloudability-billing"
  users      = ["${aws_iam_user.cloudability_billing.name}"]
  policy_arn = "${aws_iam_policy.cloudability_billing.arn}"
}

resource "aws_iam_policy" "cloudability_billing" {
    name = "cloudability-billing"
    description = "Cloudability Billing policy to allow collection of billing data"
    policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [{
   "Effect": "Allow",
   "Action": [
     "ec2:DescribeInstances",
     "ec2:DescribeImages",
     "ec2:DescribeReservedInstances",
     "ec2:DescribeReservedInstancesModifications",
     "ec2:DescribeVolumes",
     "ec2:DescribeSnapshots",
     "cloudwatch:GetMetricStatistics",
     "elasticache:DescribeReservedCacheNodes",
     "elasticache:ListTagsForResource",
     "rds:DescribeReservedDBInstances",
     "rds:ListTagsForResource",
     "redshift:DescribeReservedNodes",
     "redshift:DescribeTags"
   ],
   "Resource": "*"
  }
 ]
}
EOF
}

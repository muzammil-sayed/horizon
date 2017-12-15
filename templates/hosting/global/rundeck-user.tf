resource "aws_iam_user" "rundeck" {
  name = "rundeck"
}

resource "aws_iam_policy_attachment" "rundeck_policy_attachment" {
  name       = "rundeck-policy-attachment"
  users      = ["${aws_iam_user.rundeck.name}"]
  policy_arn = "${aws_iam_policy.rundeck_policy.arn}"
}

resource "aws_iam_policy" "rundeck_policy" {
    name = "rundeck-policy"
    description = "Rundeck policy to allow tagging"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "RundeckPolicy",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DescribeTags",
                "ec2:ResourceTag",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:RemoveTags",
                "elasticloadbalancing:AddTags",
                "elasticache:AddTagsToResource",
                "elasticache:ListTagsForResource",
                "elasticache:RemoveTagsFromResource",
                "es:AddTags",
                "es:ListTags",
                "es:RemoveTags",
                "kinesis:AddTagsToStream",
                "kinesis:ListTagsForStream",
                "kinesis:RemoveTagsFromStream",
                "rds:AddTagsToResource",
                "rds:ListTagsForResource",
                "rds:ListTagsForResource",
                "redshift:CreateTags",
                "redshift:DeleteTags",
                "redshift:DescribeTags",
                "route53:ChangeTagsForResource",
                "route53:ListTagsForResource",
                "route53:ListTagsForResources",
                "route53domains:DeleteTagsForDomain",
                "route53domains:ListTagsForDomain",
                "route53domains:UpdateTagsForDomain",
                "s3:GetBucketTagging",
                "s3:PutBucketTagging",
                "autoscaling:CreateOrUpdateTags",
                "autoscaling:DescribeTags",
                "autoscaling:DeleteTags",
                "cloudtrail:AddTags",
                "cloudtrail:ListTags",
                "cloudtrail:RemoveTags"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# The Infra account has extra S3 privileges for handling Ansible artifacts.

resource "aws_iam_user" "rundeck" {
  name = "rundeck"
}

resource "aws_iam_role" "rundeck_role" {
  name = "rundeck-role"
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

resource "aws_iam_policy" "rundeck_policy" {
    name        = "rundeck-policy"
    description = "Rundeck policy for tagging, S3 access, and K8s cluster creation."
    policy      = "${data.aws_iam_policy_document.rundeck_policy.json}"
}

resource "aws_iam_policy_attachment" "rundeck" {
    name       = "rundeck-attach"
    users      = ["${aws_iam_user.rundeck.name}"]
    roles      = ["${aws_iam_role.rundeck_role.name}", "${aws_iam_role.eni-attach.name}"]
    policy_arn = "${aws_iam_policy.rundeck_policy.arn}"
}

data "aws_iam_policy_document" "rundeck_policy" {
  statement {
    sid = "GraffitiMonkey"
    actions = [
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
      "cloudtrail:RemoveTags",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject"
    ]
    resources = ["*"]
  }
  statement {
    sid = "RundeckPremergeJobs"
    actions = [
      "ec2:RunInstances",
      "ec2:StartInstances",
      "ec2:CreateVolume",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot",
      "ec2:DetachVolume",
      "ec2:DeleteVolume",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
      "ec2:StopInstances",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:AttachNetworkInterface",
      "ec2:DetachNetworkInterface",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:AllocateAddress",
      "ec2:AssociateAddress",
      "ec2:DescribeAddresses",
      "ec2:DisassociateAddress",
      "ec2:ReleaseAddress",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:CreateLaunchConfiguration",
      "autoscaling:DeleteAutoScalingGroup",
      "autoscaling:DeleteLaunchConfiguration",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:UpdateAutoScalingGroup",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:CreateLoadBalancerListeners",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ConfigureHealthCheck",
      "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
      "elasticloadbalancing:AttachLoadBalancerToSubnets",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:GetRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:GetInstanceProfile",
      "iam:CreateInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:ListInstanceProfilesForRole",
      "iam:AddRoleToInstanceProfile"
    ]
    resources = ["*"]
  }
}

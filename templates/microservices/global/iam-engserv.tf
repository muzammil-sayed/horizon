resource "aws_iam_role" "engserv" {
  name = "engserv"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.governor_account_arn}"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role" "okta-engserv" {
  name               = "okta-engserv"
  assume_role_policy = "${data.template_file.okta-assumerole.rendered}"
}

resource "aws_iam_policy" "engserv" {
  name = "engserv"

  policy = "${data.aws_iam_policy_document.engserv_policy.json}"
}

resource "aws_iam_policy_attachment" "engserv" {
  name = "engserv"

  roles = [
    "${aws_iam_role.engserv.name}",
    "${aws_iam_role.okta-engserv.name}",
  ]

  policy_arn = "${aws_iam_policy.engserv.arn}"
}

data "aws_iam_policy_document" "engserv_policy" {
  statement {
    actions = [
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "iam:ListRoles",
      "iam:GetRole",
    ]

    resources = ["*"]
  }

  statement {
    actions = ["rds:*"]

    resources = [
      "arn:aws:rds:*:*:*:data-dbaas-aws-us-west-2-infra-brew*",
      "arn:aws:rds:*:*:*:data-dbaas-us-west-infra-brew*",
    ]
  }

  statement {
    actions = [
      "rds:CreateDBInstance",
      "rds:RestoreDBInstanceFromDBSnapshot",
    ]

    resources = [
      "arn:aws:rds:*:*:og:default:*",
      "arn:aws:rds:*:*:pg:default*",
    ]
  }

  statement {
    actions = [
      "rds:DescribeCertificates",
      "rds:DescribeDBInstances",
      "rds:DescribeDBClusters",
      "rds:DescribeDBEngineVersions",
      "rds:DescribeDBSecurityGroups",
      "rds:DescribeDBSubnetGroups",
      "rds:DescribeDBParameterGroups",
      "rds:DescribeEvents",
      "rds:DescribeEventSubscriptions",
      "rds:DescribeOptionGroups",
      "rds:DescribeOrderableDBInstanceOptions",
      "rds:DescribeDBSnapshots",
      "rds:ListTagsForResource",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "cloudwatch:describe*",
      "cloudwatch:get*",
      "cloudwatch:list*",
    ]

    resources = ["*"]
  }

  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["*"]
  }

  statement {
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::baas-s3-broker-aws-us-west-2-brewprod",
      "arn:aws:s3:::baas-s3-broker-aws-us-west-2-brewprod/*",
    ]
  }
}

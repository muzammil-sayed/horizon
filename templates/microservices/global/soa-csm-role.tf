resource "aws_iam_role" "soa-csm-audit" {
  name = "soa-csm-audit"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "soa-csm-audit" {
  name       = "soa-csm-audit"
  roles      = ["${aws_iam_role.soa-csm-audit.name}"]
  policy_arn = "${aws_iam_policy.soa-csm-audit-policy.arn}"
}

resource "aws_iam_policy" "soa-csm-audit-policy" {
  name        = "soa-csm-audit-policy"
  description = "Policy for soa-csm-audit user to manage lambda and dynamodb"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "lambda:InvokeFunction",
            "Effect": "Allow",
            "Resource": "arn:aws:lambda:*:${var.aws_account_id}:function:soa-*"
        },
        {
            "Action": [
                "dynamodb:DescribeStream",
                "dynamodb:GetRecords",
                "dynamodb:GetShardIterator",
                "dynamodb:ListStreams"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:dynamodb:*:${var.aws_account_id}:table/*/stream/soa-*"
        },
        {
            "Action": [
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:UpdateItem"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:dynamodb:*:${var.aws_account_id}:table/soa-*",
            "Sid": "DynamoDBACSMProperties"
        },
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": ""
        }
    ]
}
EOF
}

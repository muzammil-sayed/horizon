resource "aws_sqs_queue" "sync-bus-automation-1" {
  #name = "soa-identity-ms-integ-revocation"
  name = "${concat("sync-bus-","${lookup(var.mako_env, var.env)}","-automation-1")}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "arn:aws:sqs:"${var.region}":"${var.aws_account_id}":sync-bus-"${lookup(var.mako_env, var.env)}"-automation-1/SQSDefaultPolicy",
  "Statement": [
    {
      "Sid": "Sid1471470510997",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::"${var.aws_account_id}":user/mako-sync-bus-ms-"${lookup(var.mako_env, var.env)}""
      },
      "Action": "SQS:*",
      "Resource": "arn:aws:sqs:"${var.region}":"${var.aws_account_id}":sync-bus-"${lookup(var.mako_env, var.env)}"-automation-1"
    }
  ]
}
EOF
}

resource "aws_sqs_queue" "sync-bus-automation-2" {
  #name = "soa-identity-ms-integ-revocation"
  name = "${concat("sync-bus-","${lookup(var.mako_env, var.env)}","-automation-2")}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "arn:aws:sqs:"${var.region}":"${var.aws_account_id}":sync-bus-"${lookup(var.mako_env, var.env)}"-automation-2/SQSDefaultPolicy",
  "Statement": [
    {
      "Sid": "Sid1471470510997",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::"${var.aws_account_id}":user/mako-sync-bus-ms-"${lookup(var.mako_env, var.env)}""
      },
      "Action": "SQS:*",
      "Resource": "arn:aws:sqs:"${var.region}":"${var.aws_account_id}":sync-bus-"${lookup(var.mako_env, var.env)}"-automation-2"
    }
  ]
}
EOF
}


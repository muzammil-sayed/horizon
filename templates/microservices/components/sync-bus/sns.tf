resource "aws_sns_topic" "sync-bus-JiveIdUserEvents" {
  name = "${concat("sync-bus-","${lookup(var.mako_env, var.env)}" ,"-JiveIdUserEvents")}"
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::"${var.aws_account_id}":user/mako-sync-bus-ms-"${lookup(var.mako_env, var.env)}""
      },
      "Action": [
        "SNS:Publish",
        "SNS:RemovePermission",
        "SNS:SetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:Receive",
        "SNS:AddPermission",
        "SNS:Subscribe"
      ],
      "Resource": "arn:aws:sns:"${var.region}":"${var.aws_account_id}":sync-bus-"${lookup(var.mako_env, var.env)}"-JiveIdUserEvents",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${var.aws_account_id}"
        }
      }
    }
  ]
}
EOF
}


resource "aws_sns_topic" "sync-bus-JiveIdMemberEvents" {
  name = "${concat("sync-bus-","${lookup(var.mako_env, var.env)}" ,"-JiveIdMemberEvents")}"
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::"${var.aws_account_id}":user/mako-sync-bus-ms-"${lookup(var.mako_env, var.env)}""
      },
      "Action": [
        "SNS:Publish",
        "SNS:RemovePermission",
        "SNS:SetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:Receive",
        "SNS:AddPermission",
        "SNS:Subscribe"
      ],
      "Resource": "arn:aws:sns:"${var.region}":"${var.aws_account_id}":sync-bus-"${lookup(var.mako_env, var.env)}"-JiveIdMemberEvents",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${var.aws_account_id}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_sns_topic" "sync-bus-JiveIdNetworkEvents" {
  name = "${concat("sync-bus-","${lookup(var.mako_env, var.env)}" ,"-JiveIdNetworkEvents")}"
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::"${var.aws_account_id}":user/mako-sync-bus-ms-"${lookup(var.mako_env, var.env)}""
      },
      "Action": [
        "SNS:Publish",
        "SNS:RemovePermission",
        "SNS:SetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:Receive",
        "SNS:AddPermission",
        "SNS:Subscribe"
      ],
      "Resource": "arn:aws:sns:"${var.region}":"${var.aws_account_id}":sync-bus-"${lookup(var.mako_env, var.env)}"-JiveIdNetworkEvents",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${var.aws_account_id}"
        }
      }
    }
  ]
}
EOF
}




resource "aws_sns_topic" "sync-bus-JiveIdRevokeEvents" {
  name = "${concat("sync-bus-","${lookup(var.mako_env, var.env)}" ,"-JiveIdRevokeEvents")}"
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::"${var.aws_account_id}":user/mako-sync-bus-ms-"${lookup(var.mako_env, var.env)}""
      },
      "Action": [
        "SNS:Publish",
        "SNS:RemovePermission",
        "SNS:SetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:Receive",
        "SNS:AddPermission",
        "SNS:Subscribe"
      ],
      "Resource": "arn:aws:sns:"${var.region}":"${var.aws_account_id}":sync-bus-${var.env}-JiveIdRevokeEvents",
      "Resource": "arn:aws:sns:"${var.region}":"${var.aws_account_id}":sync-bus-"${lookup(var.mako_env, var.env)}"-JiveIdRevokeEvents",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${var.aws_account_id}"
        }
      }
    }
  ]
}
EOF
}



resource "aws_sns_topic_subscription" "sync-bus-JiveIdUserEvents_subscription-1" {
  topic_arn = "${aws_sns_topic.sync-bus-JiveIdUserEvents.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.sync-bus-automation-1.arn}"
}

resource "aws_sns_topic_subscription" "sync-bus-JiveIdMemberEvents_subscription-1" {
  topic_arn = "${aws_sns_topic.sync-bus-JiveIdMemberEvents.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.sync-bus-automation-1.arn}"
}
resource "aws_sns_topic_subscription" "sync-bus-JiveIdNetworkEvents_subscripsion-1" {
  topic_arn = "${aws_sns_topic.sync-bus-JiveIdNetworkEvents.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.sync-bus-automation-1.arn}"
}

resource "aws_sns_topic_subscription" "sync-bus-JiveIdRevokeEvents_subscripsion-1" {
  topic_arn = "${aws_sns_topic.sync-bus-JiveIdRevokeEvents.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.sync-bus-automation-1.arn}"
}

resource "aws_sns_topic_subscription" "sync-bus-JiveIdUserEvents_subscription-2" {
  topic_arn = "${aws_sns_topic.sync-bus-JiveIdUserEvents.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.sync-bus-automation-2.arn}"
}

resource "aws_sns_topic_subscription" "sync-bus-JiveIdMemberEvents_subscription-2" {
  topic_arn = "${aws_sns_topic.sync-bus-JiveIdMemberEvents.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.sync-bus-automation-2.arn}"
}
resource "aws_sns_topic_subscription" "sync-bus-JiveIdNetworkEvents_subscripsion-2" {
  topic_arn = "${aws_sns_topic.sync-bus-JiveIdNetworkEvents.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.sync-bus-automation-2.arn}"
}

resource "aws_sns_topic_subscription" "sync-bus-JiveIdRevokeEvents_subscripsion-2" {
  topic_arn = "${aws_sns_topic.sync-bus-JiveIdRevokeEvents.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.sync-bus-automation-2.arn}"
}

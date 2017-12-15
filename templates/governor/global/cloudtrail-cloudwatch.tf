/* The resources to setup the CloudTrail->CloudWatch integration


An imporant note on metric names conventions used for
aws_cloudwatch_log_metric_filter's:

CamelCase is not good:
    In the CloudWatch service we can use CamelCase names without issues, but
    with the Datadog integration they are converted to all lower case, which
    ugly for longer names

snake_case is also not good:
    Again, things look good in CloudWatch, but something happens when Datadog
    gets the metrics, which causes "ec2_api_requests" to show up as
    "ec_2apirequests"!??!?!  I don't even... It gets worse:
    "route53_api_requests" becomes "route_5_3apirequests".

Putting details into the namespace seems OK:
    Keep the metric names short, and use the namespace for all the additional
    details, and snake_case seems fine when used the namespace.
    Example: "aws.cloudtrail.api_requests.ec2"

*/

resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name = "cloudtrail/logs"
}

resource "aws_iam_role" "cloudtrail_cloudwatch" {
  name = "cloudtrail_cloudwatch"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "cloudtrail_cloudwatch" {
  name = "cloudtrail_cloudwatch"
  role = "${aws_iam_role.cloudtrail_cloudwatch.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailCreateLogStream",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream"
            ],
            "Resource": [
                "arn:aws:logs:${var.region}:${var.aws_account_id}:log-group:${aws_cloudwatch_log_group.cloudtrail_logs.name}:log-stream:${var.aws_account_id}_CloudTrail_${var.region}*"
            ]
        },
        {
            "Sid": "AWSCloudTrailPutLogEvents",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${var.region}:${var.aws_account_id}:log-group:${aws_cloudwatch_log_group.cloudtrail_logs.name}:log-stream:${var.aws_account_id}_CloudTrail_${var.region}*"
            ]
        }
    ]
}
EOF
}

resource "aws_cloudwatch_log_metric_filter" "api_requests_all" {
  name           = "api_requests_all"
  pattern        = ""
  log_group_name = "${aws_cloudwatch_log_group.cloudtrail_logs.name}"

  metric_transformation {
    name      = "all"
    namespace = "aws.cloudtrail.api_requests"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "api_requests_ec2" {
  name           = "api_requests_ec2"
  pattern        = "{$.eventSource = ec2.amazonaws.com}"
  log_group_name = "${aws_cloudwatch_log_group.cloudtrail_logs.name}"

  metric_transformation {
    name      = "ec2"
    namespace = "aws.cloudtrail.api_requests"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "api_requests_elb" {
  name           = "api_requests_elb"
  pattern        = "{$.eventSource = elasticloadbalancing.amazonaws.com}"
  log_group_name = "${aws_cloudwatch_log_group.cloudtrail_logs.name}"

  metric_transformation {
    name      = "elb"
    namespace = "aws.cloudtrail.api_requests"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "api_requests_route53" {
  name           = "api_requests_route53"
  pattern        = "{$.eventSource = route53.amazonaws.com}"
  log_group_name = "${aws_cloudwatch_log_group.cloudtrail_logs.name}"

  metric_transformation {
    name      = "route53"
    namespace = "aws.cloudtrail.api_requests"
    value     = "1"
  }
}

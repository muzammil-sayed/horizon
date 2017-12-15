resource "aws_cloudwatch_event_target" "asg-monitor" {
  rule = "${aws_cloudwatch_event_rule.asg-monitor.name}"
  arn  = "${aws_lambda_function.asg-monitor.arn}"
}

resource "aws_cloudwatch_event_rule" "asg-monitor" {
  name        = "capture-ec2-scaling-events"
  description = "Capture all EC2 scaling events"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.autoscaling"
  ],
  "detail-type": [
    "EC2 Instance Launch Successful",
    "EC2 Instance Terminate Successful",
    "EC2 Instance Launch Unsuccessful",
    "EC2 Instance Terminate Unsuccessful"
  ]
}
PATTERN
}

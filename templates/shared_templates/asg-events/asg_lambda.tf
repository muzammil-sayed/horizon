resource "aws_lambda_function" "asg-monitor" {
  description      = "Push ASG launch failures into diggity dog"
  filename         = "~/git/jive/code/common-services/aws-events/build/asg-latest.zip"
  function_name    = "asg-monitor"
  role             = "${aws_iam_role.asg-monitor.arn}"
  handler          = "index.handler"
  source_code_hash = "${base64sha256(file("~/git/jive/code/common-services/aws-events/build/asg-latest.zip"))}"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.asg-monitor.arn}"
  principal     = "events.amazonaws.com"
}

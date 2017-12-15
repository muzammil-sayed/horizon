#
# HEY!
# You need to zip the "union.py" file before running terraform/horizon!
#
# $ zip union.py.zip union.py
#
#
#
# First, create the role:
#
resource "aws_iam_role" "ddns_lambda_role" {
  name               = "ddns_lambda_role"
  assume_role_policy = "${file("${path.module}/ddns-trust.json")}"
}

# Now create the policy:
#
resource "aws_iam_role_policy" "ddns-lambda_role_policy" {
    name   = "ddns_lambda_role_policy"
    role   = "${aws_iam_role.ddns_lambda_role.id}"
    policy = "${file("${path.module}/ddns-pol.json")}"
}

# Next, the lambda:
#
resource "aws_lambda_function" "ddns_lambda" {
    filename = "union.py.zip"
    function_name = "ddns_lambda"
    role = "${aws_iam_role.ddns_lambda_role.arn}"
    handler = "union.lambda_handler"
    source_code_hash = "${base64sha256(file("union.py.zip"))}"
    runtime = "python2.7"
    timeout = "90"
}

# Hooray! But now we need a CloudWatch Events Rule with which to
# trigger the lambda:
#
resource "aws_cloudwatch_event_rule" "ec2_lambda_ddns_rule" {
  name = "ec2_lambda_ddns_rule"
  description = "Capture EC2 state changes to trigger DNS changes"
  event_pattern = <<PATTERN
{
  "source": ["aws.ec2"],
  "detail-type":["EC2 Instance State-change Notification"],
  "detail":{"state":["running","shutting-down","stopped"]}
}
PATTERN
}

# Great, now we need to point that rule to the lambda:
#
resource "aws_cloudwatch_event_target" "event_target_for_ec2" {
  rule = "${aws_cloudwatch_event_rule.ec2_lambda_ddns_rule.name}"
  target_id = "SendToDDNSLambda"
  arn = "${aws_lambda_function.ddns_lambda.arn}"
}

# Alright smart guy, but you're going to need to give the CW rule
# permissions to execute the lamdba:
#
resource "aws_lambda_permission" "allow_cloudwatch_for_ddns" {
  statement_id = "AllowExecutionFromCloudWatchForDDNS"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.ddns_lambda.arn}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.ec2_lambda_ddns_rule.arn}"
}


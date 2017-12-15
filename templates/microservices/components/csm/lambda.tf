

/*
resource "aws_lambda_function" "audit_lambda" {
  function_name = "${var.env}-csm-audit"
  role          = "${aws_iam_role.csm_audit_lambda_role.arn}"
  handler       = "com.jivesoftware.services.csm.audit.LambdaEventProcessor::handleRequest"
  runtime       = "java8"
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  batch_size        = 100
  event_source_arn  = "${aws_dynamodb_table.csm-properties.stream_arn}"
  enabled           = true
  function_name     = "${aws_lambda_function.audit_lambda.arn}"
  starting_position = "TRIM_HORIZON"
}
*/


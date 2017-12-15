

/*
resource "aws_lambda_function" "audit_lambda" {
    function_name = "${var.env}-affinity-audit"
    role = "${aws_iam_role.affinity_audit_lambda_role.arn}"
    handler = "com.jivesoftware.services.affinity.audit.LambdaEventProcessor::handleRequest"
    runtime = "java8"
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
    batch_size = 100
    event_source_arn = "${var.dynamodb_stream_id}"
    enabled = true
    function_name = "${aws_lambda_function.audit_lambda.arn}"
    starting_position = "TRIM_HORIZON"
}
*/


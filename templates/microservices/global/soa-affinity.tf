resource "aws_iam_role" "soa-affinity-dynamodb-lambda" {
  name = "soa-affinity-dynamodb-lambda"

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

resource "aws_iam_policy" "soa-affinity-dynamodb-lambda" {
  name = "soa-affinity-dynamodb-lambda"

  policy = "${template_file.soa-affinity-dynamodb-lambda-policy.rendered}"
}

resource "template_file" "soa-affinity-dynamodb-lambda-policy" {
  template = "${file("soa-affinity-dynamodb-lambda.policy.template")}"

  vars {
    account = "${var.aws_account_id}"
  }
}

resource "aws_iam_policy_attachment" "soa-affinity-dynamodb-lambda" {
  name = "soa-affinity-dynamodb-lambda"

  roles = [
    "${aws_iam_role.soa-affinity-dynamodb-lambda.name}",
  ]

  policy_arn = "${aws_iam_policy.soa-affinity-dynamodb-lambda.arn}"
}

resource "aws_iam_instance_profile" "sample_iam_instance_profile" {
    name = "${var.env}-sample_iam_instance_profile"
    roles = ["${var.env}-sample-role"]
}

resource "aws_iam_role" "sample_role" {
    name = "${var.env}-sample-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


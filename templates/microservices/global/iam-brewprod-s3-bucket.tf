resource "aws_iam_user" "brewprod-s3" {
  name  = "brewprod-s3"
  count = "${var.global_condition["manage_brewprod_s3_user"]}"
}

resource "aws_iam_policy_attachment" "brewprod-s3" {
  name       = "brewprod-s3"
  users      = ["${aws_iam_user.brewprod-s3.name}"]
  policy_arn = "${aws_iam_policy.brewprod-s3-policy.arn}"
  count      = "${var.global_condition["manage_brewprod_s3_user"]}"
}

# NOTE: this policy (and likely this user) are only temporary to facilitate
# the testing and development of our larger S3 migration story.
#
# At some point this (PLOPS-1337) should be replaced with the more final
# solution that we will use for customer migrations
resource "aws_iam_policy" "brewprod-s3-policy" {
  name        = "brewprod-s3-policy"
  description = "Policy for brewprod-s3 user to manage the brewprod s3 bucket."
  count       = "${var.global_condition["manage_brewprod_s3_user"]}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
              "arn:aws:s3:::baas-s3-broker-aws-us-west-2-brewprod",
              "arn:aws:s3:::baas-s3-broker-aws-us-west-2-brewprod/*"
            ]
        }
    ]
}
EOF
}

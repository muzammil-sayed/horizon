resource "aws_iam_user" "ps-ses" {
  name = "ps-ses"
}

resource "aws_iam_user_policy" "ps-ses" {
  name = "ps-ses"
  user = "${aws_iam_user.ps-ses.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [ {
        "Effect": "Allow",
        "Action": "ses:SendRawEmail",
        "Resource": "*"
    } ]
}
EOF
}

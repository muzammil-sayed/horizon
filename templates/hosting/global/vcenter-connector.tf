/*
//  I believe this is not neccessary, as our Okta login's provide this
resource "aws_iam_user" "vcenter-admin" {
  name = "vcenter-admin"
}

resource "aws_iam_policy_attachment" "vcenter-admin" {
  name       = "vcenter-admin"
  users      = ["${aws_iam_user.vcenter-admin.name}"]
  policy_arn = "${aws_iam_policy.vcenter-admin.arn}"
}

resource "aws_iam_policy" "vcenter-admin" {
  name        = "vcenter-admin"
  description = "Policy for vcenter-admin user to connect vcenter to AWS."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:*",
                "amp:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:CreateBucket",
                "s3:PutBucketAcl",
                "s3:GetBucketLocation",
                "s3:GetBucketAcl"
            ],
            "Resource": "arn:aws:s3:::export-to-s3-*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        }
    ]
}
EOF
}
*/

resource "aws_iam_user" "vcenter-connector" {
  name = "vcenter-connector"
}

resource "aws_iam_policy_attachment" "vcenter-connector" {
  name       = "vcenter-connector"
  users      = ["${aws_iam_user.vcenter-connector.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AWSConnector"
}

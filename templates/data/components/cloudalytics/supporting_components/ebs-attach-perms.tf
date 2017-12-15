resource "aws_iam_role" "ebs-attach" {
  name = "ebs-attach-role"

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

resource "aws_iam_instance_profile" "ebs-attach" {
  name  = "ebs-attach-profile"
  roles = ["${aws_iam_role.ebs-attach.name}"]
}

resource "aws_iam_role_policy" "ebs-attach" {
  name = "ebs-attach-policy"
  role = "${aws_iam_role.ebs-attach.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
              "Effect": "Allow",
              "Action": [
                "ec2:AttachVolume",
                "ec2:CreateTags",
                "ec2:DescribeInstances",
                "ec2:DescribeVolumes",
                "ec2:DetachVolume"
              ],
              "Resource": "*"
        }
    ]
}
EOF
}

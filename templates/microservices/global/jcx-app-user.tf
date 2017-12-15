resource "aws_iam_user" "jcx-app" {
  name = "jcx-app"
}

resource "aws_iam_policy_attachment" "jcx-app_policy_attachment" {
  name       = "jcx-app-policy-attachment"
  users      = ["${aws_iam_user.jcx-app.name}"]
  policy_arn = "${aws_iam_policy.jcx-app_policy.arn}"
}

resource "aws_iam_policy" "jcx-app_policy" {
    name = "jcx-app-policy"
    description = "Policy for jcx-app user to manage resources programatically."
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
         "Action":[
            "route53:ListHostedZonesByName"
         ],
         "Effect":"Allow",
         "Resource": "*"
        },
        {
         "Action":[
            "route53:GetHostedZone",
            "route53:ListResourceRecordSets",
            "route53:ChangeResourceRecordSets"
         ],
         "Effect":"Allow",
         "Resource":[
            "arn:aws:route53:::hostedzone/${aws_route53_zone.jcx_zone_1.zone_id}",
            "arn:aws:route53:::hostedzone/${aws_route53_zone.jcx_zone_2.zone_id}"
         ]
        },
        {
         "Action":"elasticloadbalancing:DescribeLoadBalancers",
         "Effect":"Allow",
         "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": [
            "dynamodb:ListTables",
            "dynamodb:DescribeTable"
          ],
          "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": "dynamodb:*",
          "Resource": "arn:aws:dynamodb:*:*:table/jcx*"
        }
    ]
}
EOF
}

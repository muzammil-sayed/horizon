resource "aws_iam_role" "jcx-administrator" {
  name = "jcx-administrator"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.governor_account_arn}"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role" "okta-jcx" {
  name               = "okta-jcx"
  assume_role_policy = "${data.template_file.okta-assumerole.rendered}"
}

resource "aws_iam_policy" "jcx-administrator" {
  name = "jcx-administrator"

  policy = "${data.template_file.jcx-administrator-policy.rendered}"
}

resource "aws_iam_policy" "jcx-administrator-route53" {
 name = "jcx-administrator-route53"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource":[
              "arn:aws:route53:::hostedzone/${aws_route53_zone.jcx_zone_1.zone_id}",
              "arn:aws:route53:::hostedzone/${aws_route53_zone.jcx_zone_2.zone_id}"
              ]
        }
    ]
}
EOF
}

data "template_file" "jcx-administrator-policy" {
  template = "${file("team.policy.template")}"

  vars {
    resource_prefix = "jcx"
  }
}

resource "aws_iam_policy_attachment" "jcx-administrator" {
  name = "jcx-administrator"

  roles = [
    "${aws_iam_role.jcx-administrator.name}",
    "${aws_iam_role.okta-jcx.name}",
  ]

  policy_arn = "${aws_iam_policy.jcx-administrator.arn}"
}

resource "aws_iam_policy_attachment" "jcx-administrator-route53" {
  name = "jcx-administrator-route53"

  roles = [
    "${aws_iam_role.jcx-administrator.name}",
    "${aws_iam_role.okta-jcx.name}",
  ]

  policy_arn = "${aws_iam_policy.jcx-administrator-route53.arn}"
}

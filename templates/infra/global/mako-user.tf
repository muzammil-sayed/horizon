data "template_file" "route53_policy" {
  template = <<TEMPLATE
{
   "Version": "2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":["route53:ChangeResourceRecordSets"],
         "Resource":["arn:aws:route53:::hostedzone/${aws_route53_zone.services.zone_id}"]
      },
      {
         "Effect":"Allow",
         "Action":["route53:GetChange"],
         "Resource":"arn:aws:route53:::change/*"
      },
      {
          "Effect": "Allow",
          "Action": "route53:ListHostedZonesByName",
          "Resource": "*"
      }]
}
TEMPLATE
}

resource "aws_iam_user" "mako-route53" {
  name = "mako-route53"
}

resource "aws_iam_user_policy" "services_route53" {
  name   = "services_route53"
  user   = "${aws_iam_user.mako-route53.name}"
  policy = "${data.template_file.route53_policy.rendered}"
}

### Infra Route53 Zone Records ###

resource "aws_route53_record" "ms-pipeline-us-master" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "ms-pipeline-us-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-pipeline-k8s-master-elb-1853603582.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "ms-prod-us-master" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "ms-prod-us-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-prod-k8s-master-elb-872272478.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "ms-pipeline-eu-master" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "ms-pipeline-eu-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-pipeline-k8s-master-elb-81483824.eu-central-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "jcx-pipeline-us-master" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "jcx-pipeline-us-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-pipeline-jcx-k8s-master-elb-1875144973.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "jcx-prod-us-master" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "jcx-prod-us-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-prod-jcx-k8s-master-elb-1703177150.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "jcx-pipeline-eu-master-elb" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "jcx-pipeline-eu-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-pipeline-jcx-k8s-master-elb-898998613.eu-central-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "bastion-us-west-2-jivew-prod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-west-2-jivew-prod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.0.7"]
}

resource "aws_route53_record" "bastion-us-west-2-jive-ps-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-west-2-jive-ps-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.57.7"]
}

resource "aws_route53_record" "bastion-us-west-2-jive-microservices-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-west-2-jive-microservices-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.30.7"]
}

resource "aws_route53_record" "bastion-us-west-2-jive-data-prod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-west-2-jive-data-prod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.27.7"]
}

resource "aws_route53_record" "bastion-us-west-2-jive-data-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-west-2-jive-data-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.21.7"]
}

resource "aws_route53_record" "bastion-eu-central-1-jive-ps-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-eu-central-1-jive-ps-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.58.7"]
}

resource "aws_route53_record" "bastion-us-west-2-jive-infra-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-west-2-jive-infra-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.63.7"]
}

resource "aws_route53_record" "bastion-us-west-2-jive-data-brewprod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-west-2-jive-data-brewprod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.24.7"]
}

resource "aws_route53_record" "bastion-eu-central-1-jive-ps-prod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-eu-central-1-jive-ps-prod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.61.7"]
}

resource "aws_route53_record" "bastion-eu-central-1-jive-microservices-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-eu-central-1-jive-microservices-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.72.7"]
}

resource "aws_route53_record" "bastion-us-west-2-jivew-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-west-2-jivew-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.8.7"]
}

resource "aws_route53_record" "bastion-eu-west-1-jive-microservices-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-eu-west-1-jive-microservices-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.31.7"]
}

resource "aws_route53_record" "bastion-us-west-2-jive-reco-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-west-2-jive-reco-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.48.7"]
}

resource "aws_route53_record" "bastion-us-west-2-jive-infra-prod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-west-2-jive-infra-prod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.67.7"]
}

resource "aws_route53_record" "bastion-us-west-2-jive-ps-prod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-west-2-jive-ps-prod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.60.7"]
}

resource "aws_route53_record" "bastion-us-west-2-jive-reco-prod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-west-2-jive-reco-prod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.54.7"]
}

resource "aws_route53_record" "bastion-eu-central-1-jive-infra-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-eu-central-1-jive-infra-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.64.7"]
}

resource "aws_route53_record" "bastion-us-west-2-jive-reco-brewprod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-west-2-jive-reco-brewprod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.51.7"]
}

resource "aws_route53_record" "bastion-us-west-2-jivew-brewprod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-west-2-jivew-brewprod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.4.7"]
}

resource "aws_route53_record" "bastion-us-west-2-jive-microservices-prod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-west-2-jive-microservices-prod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.36.7"]
}

resource "aws_route53_record" "bastion-eu-central-1-jive-reco-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-eu-central-1-jive-reco-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.78.7"]
}

resource "aws_route53_record" "bastion-eu-central-1-jive-reco-brewprod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-eu-central-1-jive-reco-brewprod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.79.7"]
}

resource "aws_route53_record" "bastion-eu-central-1-jive-reco-prod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-eu-central-1-jive-reco-prod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.80.7"]
}

resource "aws_route53_record" "bastion-eu-central-1-jive-data-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-eu-central-1-jive-data-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.69.7"]
}

resource "aws_route53_record" "bastion-eu-central-1-jive-data-brewprod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-eu-central-1-jive-data-brewprod"
  type    = "A"
  ttl     = "300"
  records = ["110.127.70.7"]
}

resource "aws_route53_record" "bastion-eu-central-1-jive-data-prod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-eu-central-1-jive-data-prod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.71.7"]
}

resource "aws_route53_record" "bastion-us-east-1-jivek8-aws" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-east-1-jivek8-aws"
  type    = "A"
  ttl     = "300"
  records = ["34.203.134.143"]
}

resource "aws_route53_record" "sam-pipeline-us-master-elb" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "sam-pipeline-us-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-pipeline-sam-k8s-master-elb-1774599046.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "dcp-pipeline-us-master-elb" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "dcp-pipeline-us-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-pipeline-dcp-k8s-master-elb-1497090711.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "bauron-pipeline-us-master-elb" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bauron-pipeline-us-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-pipeline-bauron-k8s-master-elb-415845951.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "infra-pipeline-us-master-elb" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "infra-pipeline-us-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-pipeline-k8s-master-elb-322116945.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "lemur-prod" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "lemur-prod"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-lemur-elb-1969052899.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "joe-pipeline-us-master-elb" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "joe-pipeline-us-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-pipeline-joe-k8s-master-elb-1387231120.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "sunnyd-pipeline-us-master-elb" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "sunnyd-pipeline-us-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-pipeline-sunnyd-k8s-master-elb-880772487.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "devopsil-pipeline-us-master-elb" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "devopsil-pipeline-us-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-pipeline-devopsil-k8s-master-elb-2010575691.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "bastion-us-east-1-jive-microservices-prod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-east-1-jive-microservices-prod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.44.7"]
}

resource "aws_route53_record" "bastion-us-east-1-jive-microservices-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-east-1-jive-microservices-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.43.7"]
}

resource "aws_route53_record" "bastion-us-east-1-jive-data-prod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-east-1-jive-data-prod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.28.7"]
}

resource "aws_route53_record" "bastion-us-east-1-jive-data-brewprod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-east-1-jive-data-brewprod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.23.7"]
}

resource "aws_route53_record" "bastion-us-east-1-jive-data-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-east-1-jive-data-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.22.7"]
}

resource "aws_route53_record" "bastion-us-east-1-jive-reco-prod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-east-1-jive-reco-prod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.55.7"]
}

resource "aws_route53_record" "bastion-us-east-1-jive-reco-brewprod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-east-1-jive-reco-brewprod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.52.7"]
}

resource "aws_route53_record" "bastion-us-east-1-jive-reco-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-east-1-jive-reco-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.49.7"]
}

resource "aws_route53_record" "bastion-us-east-1-jive-ps-prod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-east-1-jive-ps-prod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.62.7"]
}

resource "aws_route53_record" "bastion-us-east-1-jive-ps-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-east-1-jive-ps-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.59.7"]
}

resource "aws_route53_record" "bastion-us-east-1-jive-infra-prod-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-east-1-jive-infra-prod"
  type    = "A"
  ttl     = "300"
  records = ["10.127.26.7"]
}

resource "aws_route53_record" "bastion-us-east-1-jive-infra-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-east-1-jive-infra-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.25.7"]
}

resource "aws_route53_record" "bastion-us-east-1-jive-hosting-pipeline-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-east-1-jive-hosting-pipeline"
  type    = "A"
  ttl     = "300"
  records = ["10.127.14.7"]
}

resource "aws_route53_record" "pete-pipeline-us-master-elb" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "pete-pipeline-us-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-pipeline-pete-k8s-master-elb-1483055980.us-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "infra-pipeline-us-east-master-elb" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name = "infra-pipeline-us-east-master"
  type = "CNAME"
  ttl = "60"
  records = [
    "internal-pipeline-k8s-master-elb-1226118363.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "ms-pipeline-us-east-master-elb" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "ms-pipeline-us-east-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-pipeline-k8s-master-elb-1114365283.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "jcx-pipeline-us-east-master-elb" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "jcx-pipeline-us-east-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-pipeline-jcx-k8s-master-elb-1319957065.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "ms-prod-us-east-master-elb" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "ms-prod-us-east-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-prod-k8s-master-elb-1212043231.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "jcx-prod-us-east-master-elb" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "jcx-prod-us-east-master"
  type    = "CNAME"
  ttl     = "60"
  records = ["internal-prod-jcx-k8s-master-elb-476079142.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "bastion-us-east-1-jive-reco-sandbox-bastion" {
  zone_id = "${aws_route53_zone.infra.zone_id}"
  name    = "bastion-us-east-1-jive-reco-sandbox"
  type    = "A"
  ttl     = "300"
  records = ["10.127.50.7"]
}


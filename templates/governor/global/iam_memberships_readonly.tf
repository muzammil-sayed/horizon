resource "aws_iam_group_membership" "data-readonly" {
  name  = "data-readonly"
  group = "${aws_iam_group.data-readonly.id}"
  users = []
}

resource "aws_iam_group_membership" "microservices-readonly" {
  name  = "microservices-readonly"
  group = "${aws_iam_group.microservices-readonly.id}"

  users = [
    "${aws_iam_user.shiran_dadon.name}",
    "${aws_iam_user.rami_moshe.name}",
    "${aws_iam_user.moria_cohen.name}",
    "${aws_iam_user.tom_doron.name}",
    "${aws_iam_user.michael_lilley.name}",
    "${aws_iam_user.lior_tager.name}",
    "${aws_iam_user.stas_panchenko.name}",
    "${aws_iam_user.dor_graidy.name}",
    "${aws_iam_user.david_meoded.name}",
  ]
}

resource "aws_iam_group_membership" "reco-readonly" {
  name  = "reco-readonly"
  group = "${aws_iam_group.reco-readonly.id}"
  users = []
}

resource "aws_iam_group_membership" "jcx-readonly" {
  name  = "jcx-readonly"
  group = "${aws_iam_group.jcx-readonly.id}"
  users = []
}

resource "aws_iam_group_membership" "ps-readonly" {
  name  = "ps-readonly"
  group = "${aws_iam_group.ps-readonly.id}"
  users = []
}

resource "aws_iam_group_membership" "infra-readonly" {
  name  = "infra-readonly"
  group = "${aws_iam_group.infra-readonly.id}"
  users = []
}

resource "aws_iam_group_membership" "partnercollaboration-readonly" {
  name  = "partnercollaboration-readonly"
  group = "${aws_iam_group.partnercollaboration-readonly.id}"
  users = []
}

resource "aws_iam_group_membership" "support-readonly" {
  name  = "support-readonly"
  group = "${aws_iam_group.support-readonly.id}"
  users = []
}

resource "aws_iam_group_membership" "ps-sandbox-readonly" {
  name  = "ps-sandbox-readonly"
  group = "${aws_iam_group.ps-sandbox-readonly.id}"
  users = []
}

resource "aws_iam_group_membership" "hosting-pipeline-readonly" {
  name  = "hosting-pipeline-readonly"
  group = "${aws_iam_group.hosting-pipeline-readonly.id}"
  users = []
}

resource "aws_iam_group_membership" "bikou-readonly" {
  name  = "bikou-readonly"
  group = "${aws_iam_group.bikou-readonly.id}"
  users = []
}

resource "aws_iam_group_membership" "reco-sandbox-readonly" {
  name  = "reco-sandbox-readonly"
  group = "${aws_iam_group.reco-sandbox-readonly.id}"
  users = []
}

resource "aws_iam_group_membership" "data-poweruser" {
  name  = "data-poweruser"
  group = "${aws_iam_group.data-poweruser.id}"
  users = []
}

resource "aws_iam_group_membership" "microservices-poweruser" {
  name  = "microservices-poweruser"
  group = "${aws_iam_group.microservices-poweruser.id}"

  users = [
    "${aws_iam_user.yuval_varkel.name}",
    "${aws_iam_user.stas_spivak.name}",
    "${aws_iam_user.tzvika_stein.name}",
    "${aws_iam_user.bar_avidan.name}",
    "${aws_iam_user.matan_shukry.name}",
    "${aws_iam_user.shiran_dadon.name}",
    "${aws_iam_user.david_brown.name}",
  ]
}

resource "aws_iam_group_membership" "reco-poweruser" {
  name  = "reco-poweruser"
  group = "${aws_iam_group.reco-poweruser.id}"
  users = []
}

resource "aws_iam_group_membership" "jcx-poweruser" {
  name  = "jcx-poweruser"
  group = "${aws_iam_group.jcx-poweruser.id}"

  users = [
    "${aws_iam_user.benjamin_sherman.name}",
    "${aws_iam_user.matt_pate.name}",
  ]
}

resource "aws_iam_group_membership" "ps-poweruser" {
  name  = "ps-poweruser"
  group = "${aws_iam_group.ps-poweruser.id}"

  users = [
    "${aws_iam_user.graden_gerig.name}",
    "${aws_iam_user.austen_rustrum.name}",
    "${aws_iam_user.amber_orenstein.name}",
    "${aws_iam_user.anthony_mack.name}",
    "${aws_iam_user.drew_teeter.name}",
    "${aws_iam_user.matthew_damante.name}",
    "${aws_iam_user.nick_sherred.name}",
    "${aws_iam_user.scott_romney.name}",
    "${aws_iam_user.arnold_benson.name}",
  ]
}

resource "aws_iam_group_membership" "infra-poweruser" {
  name  = "infra-poweruser"
  group = "${aws_iam_group.infra-poweruser.id}"
  users = []
}

resource "aws_iam_group_membership" "partnercollaboration-poweruser" {
  name  = "partnercollaboration-poweruser"
  group = "${aws_iam_group.partnercollaboration-poweruser.id}"
  users = []
}

resource "aws_iam_group_membership" "support-poweruser" {
  name  = "support-poweruser"
  group = "${aws_iam_group.support-poweruser.id}"
  users = []
}

resource "aws_iam_group_membership" "ps-sandbox-poweruser" {
  name  = "ps-sandbox-poweruser"
  group = "${aws_iam_group.ps-sandbox-poweruser.id}"
  users = []
}

resource "aws_iam_group_membership" "hosting-pipeline-poweruser" {
  name  = "hosting-pipeline-poweruser"
  group = "${aws_iam_group.hosting-pipeline-poweruser.id}"
  users = []
}

resource "aws_iam_group_membership" "bikou-poweruser" {
  name  = "bikou-poweruser"
  group = "${aws_iam_group.bikou-poweruser.id}"
  users = []
}

resource "aws_iam_group_membership" "reco-sandbox-poweruser" {
  name  = "reco-sandbox-poweruser"
  group = "${aws_iam_group.reco-sandbox-poweruser.id}"
  users = []
}

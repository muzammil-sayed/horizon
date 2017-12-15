resource "aws_iam_group" "israel_dev" {
  name = "israel_dev"
}

resource "aws_iam_group_policy" "israel_dev_policy" {
  name   = "israel_dev_policy"
  group  = "${aws_iam_group.israel_dev.name}"
  policy = "${file("access_keys.policy")}"
}

resource "aws_iam_group_membership" "israel_dev" {
  name = "israel_dev_membership"

  users = [
    "${aws_iam_user.yuval_varkel.name}",
    "${aws_iam_user.stas_spivak.name}",
    "${aws_iam_user.tzvika_stein.name}",
    "${aws_iam_user.bar_avidan.name}",
    "${aws_iam_user.matan_shukry.name}",
    "${aws_iam_user.shiran_dadon.name}",
    "${aws_iam_user.rami_moshe.name}",
    "${aws_iam_user.moria_cohen.name}",
    "${aws_iam_user.tom_doron.name}",
    "${aws_iam_user.michael_lilley.name}",
    "${aws_iam_user.lior_tager.name}",
    "${aws_iam_user.stas_panchenko.name}",
    "${aws_iam_user.dor_graidy.name}",
    "${aws_iam_user.david_meoded.name}",
    "${aws_iam_user.tejinder_jheeta.name}",
    "${aws_iam_user.slava_fiodorov.name}",
    "${aws_iam_user.nikita_starchenko.name}",
    "${aws_iam_user.omer_yair.name}",
  ]

  group = "${aws_iam_group.israel_dev.name}"
}

resource "aws_iam_user" "yuval_varkel" {
  name = "yuval.varkel"
}

resource "aws_iam_user" "stas_spivak" {
  name = "stas.spivak"
}

resource "aws_iam_user" "tzvika_stein" {
  name = "tzvika.stein"
}

resource "aws_iam_user" "bar_avidan" {
  name = "bar.avidan"
}

resource "aws_iam_user" "matan_shukry" {
  name = "matan.shukry"
}

resource "aws_iam_user" "shiran_dadon" {
  name = "shiran.dadon"
}

resource "aws_iam_user" "rami_moshe" {
  name = "rami.moshe"
}

resource "aws_iam_user" "moria_cohen" {
  name = "moria.cohen"
}

resource "aws_iam_user" "tom_doron" {
  name = "tom.doron"
}

resource "aws_iam_user" "michael_lilley" {
  name = "michael.lilley"
}

resource "aws_iam_user" "lior_tager" {
  name = "lior.tager"
}

resource "aws_iam_user" "stas_panchenko" {
  name = "stas.panchenko"
}

resource "aws_iam_user" "dor_graidy" {
  name = "dor.graidy"
}

resource "aws_iam_user" "david_meoded" {
  name = "david.meoded"
}

resource "aws_iam_user" "tejinder_jheeta" {
  name = "tejinder.jheeta"
}

resource "aws_iam_user" "slava_fiodorov" {
  name = "slava.fiodorov"
}

resource "aws_iam_user" "nikita_starchenko" {
  name = "nikita.starchenko"
}

resource "aws_iam_user" "omer_yair" {
  name = "omer.yair"
}

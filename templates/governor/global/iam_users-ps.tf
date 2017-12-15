resource "aws_iam_group" "ps" {
  name = "ps"
}

resource "aws_iam_group_policy" "ps_policy" {
  name   = "ps_policy"
  group  = "${aws_iam_group.ps.name}"
  policy = "${file("access_keys.policy")}"
}

resource "aws_iam_group_membership" "ps" {
  name = "ps"

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

  group = "${aws_iam_group.ps.name}"
}

resource "aws_iam_user" "graden_gerig" {
  name = "graden.gerig"
}

resource "aws_iam_user" "austen_rustrum" {
  name = "austen.rustrum"
}

resource "aws_iam_user" "amber_orenstein" {
  name = "amber.orenstein"
}

resource "aws_iam_user" "anthony_mack" {
  name = "anthony.mack"
}

resource "aws_iam_user" "drew_teeter" {
  name = "drew.teeter"
}

resource "aws_iam_user" "matthew_damante" {
  name = "matthew.damante"
}

resource "aws_iam_user" "nick_sherred" {
  name = "nick.sherred"
}

resource "aws_iam_user" "scott_romney" {
  name = "scott.romney"
}

resource "aws_iam_user" "arnold_benson" {
  name = "arnold.benson"
}

resource "aws_iam_user" "erwin_driessen" {
  name = "erwin.driessen"
}

resource "aws_iam_user" "matt_hill" {
  name = "matt.hill"
}

resource "aws_iam_user" "sai_kolli" {
  name = "sai.kolli"
}

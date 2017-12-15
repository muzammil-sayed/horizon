resource "aws_iam_group" "data" {
  name = "data"
}

resource "aws_iam_group_policy" "data_policy" {
  name   = "data_policy"
  group  = "${aws_iam_group.data.name}"
  policy = "${file("access_keys.policy")}"
}

resource "aws_iam_group_membership" "data" {
  name = "data_membership"

  users = [
    "${aws_iam_user.chris_valaas.name}",
    "${aws_iam_user.ed_snajder.name}",
    "${aws_iam_user.tim_dooher.name}",
    "${aws_iam_user.boris_yakovito.name}",
    "${aws_iam_user.muzammil_sayed.name}",
    "${aws_iam_user.mario_marin.name}",
    "${aws_iam_user.gautam_manohar.name}",
    "${aws_iam_user.manu_kaliprasad.name}",
    "${aws_iam_user.sergei_shnerson.name}",
  ]

  group = "${aws_iam_group.data.name}"
}

# Data
resource "aws_iam_user" "chris_valaas" {
  name = "chris.valaas"
}

resource "aws_iam_user" "ed_snajder" {
  name = "ed.snajder"
}

resource "aws_iam_user" "tim_dooher" {
  name = "tim.dooher"
}

resource "aws_iam_user" "boris_yakovito" {
  name = "boris.yakovito"
}

resource "aws_iam_user" "mario_marin" {
  name = "mario.marin"
}

resource "aws_iam_user" "gautam_manohar" {
  name = "gautam.manohar"
}

resource "aws_iam_user" "daniel_harada" {
  name = "daniel.harada"
}

resource "aws_iam_user" "manu_kaliprasad" {
  name = "manu.kaliprasad"
}

resource "aws_iam_user" "sergei_shnerson" {
  name = "sergei.shnerson"
}

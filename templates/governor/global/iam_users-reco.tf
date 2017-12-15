resource "aws_iam_group" "reco" {
  name = "reco"
}

resource "aws_iam_group_policy" "reco_policy" {
  name   = "reco_policy"
  group  = "${aws_iam_group.reco.name}"
  policy = "${file("access_keys.policy")}"
}

resource "aws_iam_group_membership" "reco" {
  name = "reco_membership"

  users = [
    "${aws_iam_user.bruce_downs.name}",
    "${aws_iam_user.david_brown.name}",
    "${aws_iam_user.murali_seetharaman.name}",
    "${aws_iam_user.victor_akinwande.name}",
    "${aws_iam_user.craig_mcclanahan.name}",
    "${aws_iam_user.rahul_sharma.name}",
  ]

  group = "${aws_iam_group.reco.name}"
}

resource "aws_iam_user" "bruce_downs" {
  name = "bruce.downs"
}

resource "aws_iam_user" "murali_seetharaman" {
  name = "murali.seetharaman"
}

resource "aws_iam_user" "victor_akinwande" {
  name = "victor.akinwande"
}

resource "aws_iam_user" "craig_mcclanahan" {
  name = "craig.mcclanahan"
}

resource "aws_iam_user" "rahul_sharma" {
  name = "rahul.sharma"
}

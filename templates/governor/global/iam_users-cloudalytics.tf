resource "aws_iam_group" "cloudalytics" {
  name = "cloudalytics"
}

resource "aws_iam_group_policy" "cloudalytics_policy" {
  name   = "cloudalytics_policy"
  group  = "${aws_iam_group.cloudalytics.name}"
  policy = "${file("access_keys.policy")}"
}

resource "aws_iam_group_membership" "cloudalytics" {
  name = "cloudalytics"

  users = [
    "${aws_iam_user.muzammil_sayed.name}",
    "${aws_iam_user.minas_magdi.name}",
    "${aws_iam_user.boris_yakovito.name}",
    "${aws_iam_user.guro_bokum.name}",
  ]

  group = "${aws_iam_group.cloudalytics.name}"
}

resource "aws_iam_user" "muzammil_sayed" {
  name = "muzammil.sayed"
}

resource "aws_iam_user" "minas_magdi" {
  name = "minas.magdi"
}

resource "aws_iam_user" "guro_bokum" {
  name = "guro.bokum"
}

resource "aws_iam_group" "cloudsearch" {
  name = "cloudsearch"
}

resource "aws_iam_group_policy" "cloudsearch_policy" {
  name   = "cloudsearch_policy"
  group  = "${aws_iam_group.cloudsearch.name}"
  policy = "${file("access_keys.policy")}"
}

resource "aws_iam_group_membership" "cloudsearch" {
  name = "cloudsearch"

  users = [
    "${aws_iam_user.alexey_zotov.name}",
    "${aws_iam_user.robert_browning.name}",
    "${aws_iam_user.benji_smith.name}",
  ]

  group = "${aws_iam_group.cloudsearch.name}"
}

resource "aws_iam_user" "alexey_zotov" {
  name = "alexey.zotov"
}

resource "aws_iam_user" "robert_browning" {
  name = "robert.browning"
}

resource "aws_iam_user" "benji_smith" {
  name = "benji.smith"
}

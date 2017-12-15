resource "aws_iam_group" "sandbox" {
  name = "sandbox"
}

resource "aws_iam_group_policy" "sandbox" {
  name  = "sandbox"
  group = "${aws_iam_group.sandbox.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::072535113705:role/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group_membership" "sandbox-membership" {
  name = "sandbox-membership"

  users = [
    "${aws_iam_user.benjamin_sherman.name}",
    "${aws_iam_user.bruce_downs.name}",
    "${aws_iam_user.chris_valaas.name}",
    "${aws_iam_user.ed_snajder.name}",
    "${aws_iam_user.tim_dooher.name}",
    "${aws_iam_user.graden_gerig.name}",
    "${aws_iam_user.austen_rustrum.name}",
    "${aws_iam_user.amber_orenstein.name}",
    "${aws_iam_user.anthony_mack.name}",
    "${aws_iam_user.drew_teeter.name}",
    "${aws_iam_user.matthew_damante.name}",
    "${aws_iam_user.nick_sherred.name}",
    "${aws_iam_user.scott_romney.name}",
    "${aws_iam_user.arnold_benson.name}",
    "${aws_iam_user.frank_davalos.name}",
    "${aws_iam_user.david_throckmorton.name}",
    "${aws_iam_user.paul_wroe.name}",
    "${aws_iam_user.adam_luckey.name}",
    "${aws_iam_user.shimran_george.name}",
  ]

  group = "${aws_iam_group.sandbox.name}"
}

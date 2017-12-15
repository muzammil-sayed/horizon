resource "aws_iam_group" "jcx" {
  name = "jcx"
}

resource "aws_iam_group_policy" "jcx_policy" {
  name   = "jcx_policy"
  group  = "${aws_iam_group.jcx.name}"
  policy = "${file("access_keys.policy")}"
}

resource "aws_iam_group_membership" "jcx" {
  name = "jcx_membership"

  users = [
    "${aws_iam_user.benjamin_sherman.name}",
    "${aws_iam_user.matt_pate.name}",
    "${aws_iam_user.aaron_shaver.name}",
    "${aws_iam_user.srikanth_gauthareddy.name}", 
    "${aws_iam_user.niels_bischof.name}", 
    "${aws_iam_user.zsolt_katona.name}", 
    "${aws_iam_user.sana_majeed.name}",
    "${aws_iam_user.manimaran_selvan.name}",
]

  group = "${aws_iam_group.jcx.name}"
}

resource "aws_iam_group" "jcx-pipeline-roles" {
  name = "jcx-pipeline-roles"
}

resource "aws_iam_group_policy" "jcx-pipeline-roles" {
  name  = "jcx-pipeline-roles"
  group = "${aws_iam_group.jcx-pipeline-roles.id}"

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
        "arn:aws:iam::811034720611:role/jcx*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group_membership" "jcx-pipeline-roles" {
  name = "jcx-pipeline-roles-membership"

  users = [
    "${aws_iam_user.benjamin_sherman.name}",
    "${aws_iam_user.matt_pate.name}",
    "${aws_iam_user.aaron_shaver.name}",
    "${aws_iam_user.srikanth_gauthareddy.name}",
    "${aws_iam_user.niels_bischof.name}",
    "${aws_iam_user.zsolt_katona.name}",
    "${aws_iam_user.manimaran_selvan.name}",
  ]

  group = "${aws_iam_group.jcx-pipeline-roles.name}"
}

resource "aws_iam_user" "sana_majeed" {
  name = "sana.majeed"
}

resource "aws_iam_user" "benjamin_sherman" {
  name = "benjamin.sherman"
}

resource "aws_iam_user" "matt_pate" {
  name = "matt.pate"
}

resource "aws_iam_user" "aaron_shaver" {
  name = "aaron.shaver"
}

resource "aws_iam_user" "srikanth_gauthareddy" {
  name = "srikanth.gauthareddy"
}

resource "aws_iam_user" "niels_bischof" {
  name = "niels.bischof"
}

resource "aws_iam_user" "zsolt_katona" {
  name = "zsolt.kotana"
}

resource "aws_iam_user" "manimaran_selvan" {
  name = "manimaran.selvan"
}

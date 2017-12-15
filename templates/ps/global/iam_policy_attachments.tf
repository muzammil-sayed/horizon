resource "aws_iam_policy_attachment" "readonly" {
  name = "readonly"

  roles = [
    "${aws_iam_role.readonly.name}",
  ]

  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_policy_attachment" "poweruser" {
  name = "poweruser"

  roles = [
    "${aws_iam_role.poweruser.name}",
  ]

  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_policy_attachment" "administrator" {
  name = "administrator"

  roles = [
    "${aws_iam_role.administrator.name}",
  ]

  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_policy_attachment" "ps-server-cert" {
  name = "ps-server-cert"

  roles = [
    "${aws_iam_role.poweruser.name}",
  ]

  policy_arn = "${aws_iam_policy.ps-server-cert.arn}"
}

resource "aws_iam_policy_attachment" "ps-instance-profiles" {
  name = "ps-instance-profiles"

  roles = [
    "${aws_iam_role.poweruser.name}",
  ]

  policy_arn = "${aws_iam_policy.ps-instance-profiles.arn}"
}

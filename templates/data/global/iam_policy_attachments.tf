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

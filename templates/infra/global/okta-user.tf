resource "aws_iam_user" "okta" {
  name = "okta"
}

resource "aws_iam_policy_attachment" "iam_okta_full_access" {
  name       = "iam_okta_full_access"
  users      = ["${aws_iam_user.okta.name}"]
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

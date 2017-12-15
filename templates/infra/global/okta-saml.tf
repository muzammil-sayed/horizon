# SAML provider
resource "aws_iam_saml_provider" "default" {
  name                   = "okta"
  saml_metadata_document = "${file("okta/${var.aws_account_short_name}-saml-metadata.xml")}"
}

# IAM assume role policy doc
data "template_file" "okta-assumerole" {
  template = "${file("okta/okta-assumerole.policy.template")}"

  vars {
    saml_provider_arn = "${aws_iam_saml_provider.default.arn}"
  }
}

# IAM Roles
resource "aws_iam_role" "okta-administrator" {
  name               = "okta-administrator"
  assume_role_policy = "${data.template_file.okta-assumerole.rendered}"
}

resource "aws_iam_role" "okta-poweruser" {
  name               = "okta-poweruser"
  assume_role_policy = "${data.template_file.okta-assumerole.rendered}"
}

resource "aws_iam_role" "okta-readonly" {
  name               = "okta-readonly"
  assume_role_policy = "${data.template_file.okta-assumerole.rendered}"
}

# IAM Policies
resource "aws_iam_policy" "okta-administrator" {
  name   = "okta-administrator"
  policy = "${file("okta/okta-administrator.policy")}"
}

resource "aws_iam_policy" "okta-poweruser" {
  name   = "okta-poweruser"
  policy = "${file("okta/okta-poweruser.policy")}"
}

resource "aws_iam_policy" "okta-readonly" {
  name   = "okta-readonly"
  policy = "${file("okta/okta-readonly.policy")}"
}

# IAM Policy attachments
resource "aws_iam_policy_attachment" "okta-administrator" {
  name = "okta-administrator"

  roles = [
    "${aws_iam_role.okta-administrator.name}",
  ]

  policy_arn = "${aws_iam_policy.okta-administrator.arn}"
}

resource "aws_iam_policy_attachment" "okta-poweruser" {
  name = "okta-poweruser"

  roles = [
    "${aws_iam_role.okta-poweruser.name}",
  ]

  policy_arn = "${aws_iam_policy.okta-poweruser.arn}"
}

resource "aws_iam_policy_attachment" "okta-readonly" {
  name = "okta-readonly"

  roles = [
    "${aws_iam_role.okta-readonly.name}",
  ]

  policy_arn = "${aws_iam_policy.okta-readonly.arn}"
}

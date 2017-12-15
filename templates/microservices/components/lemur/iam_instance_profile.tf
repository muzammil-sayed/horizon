resource "aws_iam_instance_profile" "lemur_profile" {
  name  = "${var.env}-lemur_profile"
  roles = ["${aws_iam_role.lemur_role.name}"]
}

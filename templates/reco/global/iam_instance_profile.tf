resource "aws_iam_instance_profile" "ansible" {
  name  = "ansible-profile"
  roles = ["${aws_iam_role.ansible.name}"]
}

resource "aws_iam_instance_profile" "upena" {
  name  = "upena-profile"
  roles = ["${aws_iam_role.upena.name}"]
}

resource "aws_iam_instance_profile" "eni-attach" {
  name  = "eni-attach-profile"
  roles = ["${aws_iam_role.eni-attach.name}"]
}

resource "aws_iam_instance_profile" "k8s-master" {
  name  = "${var.region}_${var.aws_account_short_name}-k8s-master-profile"
  roles = ["${aws_iam_role.k8s-master.name}"]
}

resource "aws_iam_instance_profile" "k8s-node" {
  name  = "${var.region}_${var.aws_account_short_name}-k8s-node-profile"
  roles = ["${aws_iam_role.k8s-node.name}"]
}

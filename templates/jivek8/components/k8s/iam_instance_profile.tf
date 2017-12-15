resource "aws_iam_instance_profile" "k8s-master" {
  name  = "${null_resource.k8s_cluster.triggers.name}-k8s-master-profile"
  roles = ["${aws_iam_role.k8s-master.name}"]
}

resource "aws_iam_instance_profile" "k8s-node" {
  name  = "${null_resource.k8s_cluster.triggers.name}-k8s-node-profile"
  roles = ["${aws_iam_role.k8s-node.name}"]
}

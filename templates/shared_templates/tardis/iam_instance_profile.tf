resource "aws_iam_instance_profile" "tardis" {
  name  = "${null_resource.k8s_cluster.triggers.name}-tardis-profile"
  roles = ["${aws_iam_role.tardis.name}"]
}

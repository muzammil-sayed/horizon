# Unfortunate workaround for terraform's lack of variable interpolation. The
# interpolated cluster name can be refrenced like a variable in other
# terraform files as:
#
#    ${null_resource.k8s_cluster.triggers.name}
#
resource "null_resource" "k8s_cluster" {
  triggers {
    name = "${var.region}_${var.aws_account_short_name}${var.kube_extra_id}"
  }
}

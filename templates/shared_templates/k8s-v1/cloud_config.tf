resource "template_file" "cloud_config" {
  template = "${file("${path.module}/cloud-config.yaml.template")}"

  vars {
    KubernetesCluster = "${var.region}_${var.aws_account_short_name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

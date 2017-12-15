data "template_file" "cloud_config" {
  template = "${file("${path.module}/cloud-config.yaml.template")}"

  vars {
    KubernetesCluster = "${null_resource.k8s_cluster.triggers.name}"
  }
}

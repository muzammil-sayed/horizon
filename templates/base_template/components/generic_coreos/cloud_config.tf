resource "template_file" "cloud_config" {
  template = "${file("${path.module}/cloud-config.yaml.template")}"

  lifecycle {
    create_before_destroy = true
  }
}

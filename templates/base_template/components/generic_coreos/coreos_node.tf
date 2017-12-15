resource "aws_instance" "generic_coreos" {
  ami                    = "${var.coreos_ami}"
  instance_type          = "${var.coreos_instance_type}"
  key_name               = "${var.coreos_keypair}"
  vpc_security_group_ids = ["${var.aws_security_group_env_instance}"]
  subnet_id              = "${lookup(var.aws_subnet_natdc, "key${count.index}")}"
  count                  = 1

  user_data = "${template_file.cloud_config.rendered}"

  root_block_device = {
    volume_type = "gp2"
  }

  tags {
    Name              = "${var.env}-generic_coreos"
    pipeline_phase    = "${var.env}"
    jive_service      = "infrastructure"
    service_component = "coreos-test-node"
  }
}

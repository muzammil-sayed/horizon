resource "aws_instance" "resonata" {
  ami                         = "${var.resonata_image_id}"
  associate_public_ip_address = false
  instance_type               = "${var.resonata_instance_type }"
  key_name                    = "${var.keypair}"
  subnet_id                   = "${lookup(var.aws_subnet_natdc, "key2")}"
  user_data                   = "${data.template_file.resonata_user_data.rendered}"

  security_groups = [
    "${var.aws_security_group_env_instance}",
    "${aws_security_group.resonata.id}",
  ]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "30"
    delete_on_termination = true
  }

  tags {
    Name            = "${var.env}-${var.jive_subservice}"
    pipeline_phase  = "${var.env}"
    jive_service    = "${var.jive_service}"
    jive_subservice = "${var.jive_subservice}"
    sla             = "${var.sla}"
  }
}

data "template_file" "resonata_user_data" {
  template = "${file("${path.module}/user-data.sh")}"
}

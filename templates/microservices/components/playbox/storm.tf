resource "aws_instance" "playbox_nimbus" {
  ami = "${var.playbox_ami}"
  instance_type = "${var.playbox_nimbus_instance_type }"
  key_name = "${var.playbox_keypair}"
  vpc_security_group_ids = ["${aws_security_group.playbox_nimbus.id}","${aws_security_group.playbox_common.id}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${count.index}")}"
  root_block_device = {
    volume_type = "gp2"
  }
  ebs_optimized = "${var.playbox_ebs_optimized}"
  count = "${var.playbox_nimbus_instance_count}"
  tags {
    Name               = "${var.env}-playbox-nimbus${count.index+1}.jiveprivate.com"
    Node_index         = "${count.index + 1}"
    Pipeline_phase     = "${var.env}"
    Jive_service       = "${var.jive_service}"
    Service_component  = "nimbus"
    Terraform_file     = "microservices/playbox/nimbus.tf"
    Terraform_resource = "aws_instance.playbox_nimbus"
  }
}
resource "aws_route53_record" "playbox_nimbus" {
   zone_id = "${var.jiveprivate_zone_id}"
   name = "${var.env}-playbox-nimbus${count.index + 1}.jiveprivate.com"
   type = "A"
   ttl = "300"
   records = ["${element(aws_instance.playbox_nimbus.*.private_ip, count.index)}"]
   count = "${var.playbox_nimbus_instance_count}"
}

resource "aws_instance" "playbox_supervisor" {
  ami = "${var.playbox_ami}"
  instance_type = "${var.playbox_supervisor_instance_type }"
  key_name = "${var.playbox_keypair}"
  vpc_security_group_ids = ["${aws_security_group.playbox_common.id}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${count.index}")}"
  root_block_device = {
    volume_type = "gp2"
  }
  ebs_optimized = "${var.playbox_ebs_optimized}"
  count = "${var.playbox_supervisor_instance_count}"
  tags {
    Name               = "${var.env}-playbox-supervisor${count.index+1}.jiveprivate.com"
    Node_index         = "${count.index + 1}"
    Pipeline_phase     = "${var.env}"
    Jive_service       = "${var.jive_service}"
    Service_component  = "supervisor"
    Terraform_file     = "microservices/playbox/supervisor.tf"
    Terraform_resource = "aws_instance.playbox_supervisor"
  }
}
resource "aws_route53_record" "playbox_supervisor" {
   zone_id = "${var.jiveprivate_zone_id}"
   name = "${var.env}-playbox-supervisor${count.index + 1}.jiveprivate.com"
   type = "A"
   ttl = "300"
   records = ["${element(aws_instance.playbox_supervisor.*.private_ip, count.index)}"]
   count = "${var.playbox_supervisor_instance_count}"
}


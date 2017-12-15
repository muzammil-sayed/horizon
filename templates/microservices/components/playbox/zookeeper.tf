resource "aws_instance" "playbox_zookeeper" {
  ami = "${var.playbox_ami}"
  instance_type = "${var.playbox_zookeeper_instance_type }"
  key_name = "${var.playbox_keypair}"
  vpc_security_group_ids = ["${aws_security_group.playbox_zookeeper.id}","${aws_security_group.playbox_common.id}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${count.index}")}"
  root_block_device = {
    volume_type = "gp2"
  }
  ebs_optimized = "${var.playbox_ebs_optimized}"
  count = "${var.playbox_zookeeper_instance_count}"
  tags {
    Name               = "${var.env}-playbox-zookeeper${count.index+1}.jiveprivate.com"
    Node_index         = "${count.index + 1}"
    Pipeline_phase     = "${var.env}"
    Jive_service       = "${var.jive_service}"
    Service_component  = "zookeeper"
    Terraform_file     = "microservices/playbox/zookeeper.tf"
    Terraform_resource = "aws_instance.playbox_zookeeper"
  }
}
resource "aws_route53_record" "playbox_zookeeper" {
   zone_id = "${var.jiveprivate_zone_id}"
   name = "${var.env}-playbox-zookeeper${count.index + 1}.jiveprivate.com"
   type = "A"
   ttl = "300"
   records = ["${element(aws_instance.playbox_zookeeper.*.private_ip, count.index)}"]
   count = "${var.playbox_zookeeper_instance_count}"
}

resource "aws_ebs_volume" "playbox_zookeeper_volume" {
    availability_zone = "${element(aws_instance.playbox_zookeeper.*.availability_zone, count.index % 3)}"
    encrypted = true
    size = "${var.playbox_zookeeper_volume_size}"
    type = "gp2"
    count = "${var.playbox_zookeeper_instance_count}"
    tags {
        Name                    = "${var.env}-playbox-zookeeper-volume${count.index+1}"
        Pipeline_phase          = "${var.env}"
        Jive_service            = "${var.jive_service}"
        Service_component       = "zookeeper"
        Terraform_file          = "microservices/playbox/zookeeper.tf"
        Terraform_resource      = "aws_ebs_volume.playbox_zookeeper_volume"
    }
}

resource "aws_volume_attachment" "playbox_zookeeper_volume_attachment" {
    device_name = "/dev/sdb"
    volume_id = "${element(aws_ebs_volume.playbox_zookeeper_volume.*.id, count.index)}"
    instance_id = "${element(aws_instance.playbox_zookeeper.*.id, count.index)}"
    force_detach = true
    count = "${var.playbox_zookeeper_instance_count}"
}

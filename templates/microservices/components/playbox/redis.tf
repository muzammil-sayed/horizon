resource "aws_instance" "playbox_redis" {
  ami = "${var.playbox_ami}"
  instance_type = "${var.playbox_redis_instance_type }"
  key_name = "${var.playbox_keypair}"
  vpc_security_group_ids = ["${aws_security_group.playbox_redis.id}","${aws_security_group.playbox_common.id}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${count.index}")}"
  root_block_device = {
    volume_type = "gp2"
  }
  count = "${var.playbox_redis_instance_count}"
  tags {
    Name               = "${var.env}-playbox-redis.jiveprivate.com"
    Node_index         = "${count.index + 1}"
    Pipeline_phase     = "${var.env}"
    Jive_service       = "${var.jive_service}"
    Service_component  = "redis"
    Terraform_file     = "microservices/playbox/redis.tf"
    Terraform_resource = "aws_instance.playbox_redis"
  }
}

resource "aws_route53_record" "playbox_redis" {
   zone_id = "${var.jiveprivate_zone_id}"
   name = "${var.env}-playbox-redis.jiveprivate.com"
   type = "A"
   ttl = "300"
   records = ["${aws_instance.playbox_redis.private_ip}"]
}

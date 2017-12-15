resource "aws_instance" "test_node" {
  ami                    = "ami-6d1c2007"
  instance_type          = "t2.micro"
  key_name               = "microservices-prod"
  vpc_security_group_ids = ["${var.aws_security_group_env_instance}"]
  subnet_id              = "${lookup(var.aws_subnet_natdc, "key${count.index}")}"

  #user_data              = "${file("./test_node.sh")}"
  count = 1

  root_block_device = {
    volume_type = "gp2"
  }

  tags {
    Name              = "${var.env}-test-node"
    pipeline_phase    = "${var.env}"
    jive_service      = "infrastructure"
    service_component = "test-node"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
  }
}

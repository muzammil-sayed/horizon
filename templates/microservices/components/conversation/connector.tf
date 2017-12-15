resource "aws_instance" "conversation_connector" {
  ami = "${var.conversation_ami}"
  instance_type = "${var.conversation_connector_instance_type }"
  key_name = "${var.conversation_keypair}"
  vpc_security_group_ids = ["${var.aws_security_group_env_instance}", "${aws_security_group.conversation_connector.id}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${count.index%3}")}"
  root_block_device = {
    volume_type = "gp2"
    volume_size = 30
  }
  ebs_optimized = "${var.conversation_ebs_optimized}"
  count = "${var.conversation_connector_instance_count}"
  tags {
    Name               = "${var.env}-conversation-connector${count.index+1}.jiveprivate.com"
    Node_index         = "${count.index + 1}"
    Pipeline_phase     = "${var.env}"
    Jive_service       = "${var.jive_service}"
    Service_component  = "connector"
    Terraform_file     = "microservices/conversation/connector.tf"
    Terraform_resource = "aws_instance.conversation_connector"
  }
}

resource "aws_route53_record" "conversation_connector" {
   zone_id = "${var.jiveprivate_zone_id}"
   name = "${var.env}-conversation-connector${count.index + 1}.jiveprivate.com"
   type = "A"
   ttl = "300"
   records = ["${element(aws_instance.conversation_connector.*.private_ip, count.index)}"]
   count = "${var.conversation_connector_instance_count}"
}

resource "aws_elb" "conversation_connectors_elb" {
   name 		= "${var.env}-gcb-connectors-elb"
   subnets         	= ["${lookup(var.aws_subnet_natdc, "key${count.index%3}")}"]
   security_groups 	= ["${aws_security_group.conversation_connectors_elb.id}"]
   
   listener {
     instance_port      = 8080
     instance_protocol  = "tcp"
     lb_port            = 443
     lb_protocol        = "tcp"
   }

   health_check {
     healthy_threshold   = 2
     unhealthy_threshold = 2
     timeout             = 5
     target              = "TCP:55001"
     interval            = 30
   }

   instances 		= ["${aws_instance.conversation_connector.*.id}"]
   idle_timeout		= 1800

   tags {
     Name 		= "${var.env}-conversation-connectors-elb"
     Hostname 		= "${var.env}-conversation-connectors.jiveprivate.com"
     Pipeline_phase	= "${var.env}"
     Jive_service	= "conversation"
     Service_component	= "connector"
   }
}

resource "aws_route53_record" "conversation_connectors_elb" {
   zone_id = "${var.jiveprivate_zone_id}"
   name = "${var.env}-conversation-connectors.jiveprivate.com"
   type = "CNAME"
   ttl = "300"
   records = ["${aws_elb.conversation_connectors_elb.dns_name}"]
}

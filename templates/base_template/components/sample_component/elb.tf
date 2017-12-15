resource "aws_elb" "sample_elb" {
    name = "${var.env}-sample-elb"
    security_groups = ["${aws_security_group.sample_security_group.id}"]
    subnets = ["${lookup(var.aws_subnet_public, "key0")}", "${lookup(var.aws_subnet_public, "key1")}", "${lookup(var.aws_subnet_public, "key2")}"]
    instances = ["${aws_instance.sample_node.*.id}"]
    idle_timeout = 60
    cross_zone_load_balancing = true
    listener {
        lb_port = 443
        lb_protocol = "HTTPS"
        ssl_certificate_id = "${var.sample_elb_cert}"
        instance_protocol = "http"
        instance_port = 8080
    }
    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:8080/checks/heartbeat"
        interval = 15
    }
    tags {
        Name                    = "${var.env}-sample-elb"
        pipeline_phase          = "${var.env}"
        region                  = "${var.region}"
        jive_service            = "${var.region}_${var.aws_account_short_name}"
        service_component       = "sample"
    }

}


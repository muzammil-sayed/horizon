resource "aws_instance" "sample_node" {
    ami = "ami-d2c924b2"
    instance_type = "t2.micro"
    key_name = "${var.sample_keypair}"
    vpc_security_group_ids = ["${aws_security_group.sample_security_group.id}", "${var.aws_security_group_env_instance}"]
    subnet_id = "${lookup(var.aws_subnet_natdc, "key${count.index}")}"
    iam_instance_profile = "${aws_iam_instance_profile.sample_iam_instance_profile.name}"
    count = 3

    root_block_device = {
        volume_type = "gp2"
    }

    tags {
        Name                    = "${var.env}-sample-instance"
        pipeline_phase          = "${var.env}"
        region                  = "${var.region}"
        jive_service            = "${var.region}_${var.aws_account_short_name}"
        service_component       = "sample"
    }

}


resource "aws_ebs_volume" "resonata_volume_mongodb" {
  availability_zone = "${var.region}${var.az["az3"]}"
  encrypted         = true
  size              = "${var.resonata_volume_size}"
  type              = "gp2"

  tags {
    name            = "${var.env}-${var.jive_subservice_short_name}-mongodb"
    pipeline_phase  = "${var.env}"
    jive_service    = "${var.jive_service}"
    jive_subservice = "${var.jive_subservice}"
    sla             = "${var.sla}"
  }
}

resource "aws_volume_attachment" "volume_attachment_resonata_mongodb" {
  device_name  = "/dev/xvdv"
  volume_id    = "${aws_ebs_volume.resonata_volume_mongodb.id}"
  instance_id  = "${aws_instance.resonata.id}"
  force_detach = true
}

resource "aws_ebs_volume" "resonata_volume_repositories" {
  availability_zone = "${var.region}${var.az["az3"]}"
  encrypted         = true
  size              = "${var.resonata_volume_size}"
  type              = "gp2"

  tags {
    name            = "${var.env}-${var.jive_subservice_short_name}-repositories"
    pipeline_phase  = "${var.env}"
    jive_service    = "${var.jive_service}"
    jive_subservice = "${var.jive_subservice}"
    sla             = "${var.sla}"
  }
}

resource "aws_volume_attachment" "volume_attachment_resonata_repositories" {
  device_name  = "/dev/xvdw"
  volume_id    = "${aws_ebs_volume.resonata_volume_repositories.id}"
  instance_id  = "${aws_instance.resonata.id}"
  force_detach = true
}

resource "aws_ebs_volume" "resonata_volume_rabbitmq" {
  availability_zone = "${var.region}${var.az["az3"]}"
  encrypted         = true
  size              = "${var.resonata_volume_size}"
  type              = "gp2"

  tags {
    name            = "${var.env}-${var.jive_subservice_short_name}-rabbitmq"
    pipeline_phase  = "${var.env}"
    jive_service    = "${var.jive_service}"
    jive_subservice = "${var.jive_subservice}"
    sla             = "${var.sla}"
  }
}

resource "aws_volume_attachment" "volume_attachment_resonata_rabbitmq" {
  device_name  = "/dev/xvdx"
  volume_id    = "${aws_ebs_volume.resonata_volume_rabbitmq.id}"
  instance_id  = "${aws_instance.resonata.id}"
  force_detach = true
}

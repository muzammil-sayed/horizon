#----------------------------------------------------------------------------------------
# Instance __INSTANCE__ Volume __VOLUME__
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena___TYPE___i__INSTANCE___v__VOLUME__" {
  availability_zone = "${var.upena___TYPE___enabled["i__INSTANCE___az"]}"
  encrypted = true
  size = "${var.upena___TYPE___volume_size}"
  type = "${var.upena___TYPE___volume_type}"
  count = "${var.upena___TYPE___enabled["i__INSTANCE___v__VOLUME__"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-__TYPE__-i__INSTANCE__-v__VOLUME__"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-__TYPE__"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena___TYPE___i__INSTANCE___av__VOLUME__" {
  device_name = "/dev/sd__DEVICE__"
  volume_id = "${aws_ebs_volume.upena___TYPE___i__INSTANCE___v__VOLUME__.id}"
  instance_id = "${aws_instance.upena___TYPE___i__INSTANCE__.id}"
  force_detach = true
  count = "${var.upena___TYPE___enabled["i__INSTANCE___v__VOLUME__"]}"
}

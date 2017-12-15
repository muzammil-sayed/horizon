#----------------------------------------------------------------------------------------
# Instance __INSTANCE__
#----------------------------------------------------------------------------------------

resource "aws_instance" "upena___TYPE___i__INSTANCE__" {
  count = "${var.upena___TYPE___enabled["i__INSTANCE__"]}"
  ami = "${var.upena___TYPE___ami}"
  instance_type = "${var.upena___TYPE___enabled["i__INSTANCE___instance_type"]}"
  ebs_optimized = "${var.upena___TYPE___instance_ebs_optimized}"
  availability_zone = "${var.upena___TYPE___enabled["i__INSTANCE___az"]}"
  key_name = "${var.upena_keypair}"
  iam_instance_profile = "${var.aws_iam_instance_profile_upena}"
  vpc_security_group_ids = [
    "${aws_security_group.upena___TYPE___sg.id}",
    "${var.aws_security_group_env_instance}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${var.upena___TYPE___enabled["i__INSTANCE___subnet_key"]}")}"

  root_block_device = {
    volume_type = "standard"
    volume_size = "8"
  }

  user_data = "${format(file(var.upena___TYPE___enabled["i__INSTANCE___bootstrap"]), "${var.region}-${var.aws_account_short_name}-${var.upena_s3_bucket}")}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-__TYPE__-i__INSTANCE__"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-__TYPE__"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_record" "newpena___TYPE___ri__INSTANCE__" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.region}-${var.aws_account_short_name}-newpena-__TYPE__-i__INSTANCE__"
  type = "A"
  ttl = "60"
  records = [
    "${aws_instance.upena___TYPE___i__INSTANCE__.private_ip}"
  ]
  count = "${var.upena___TYPE___enabled["i__INSTANCE__"]}"
}

resource "aws_ebs_volume" "upena___TYPE___i__INSTANCE___v0" {
  availability_zone = "${var.upena___TYPE___enabled["i__INSTANCE___az"]}"
  encrypted = true
  size = "500"
  type = "st1"
  count = "${var.upena___TYPE___enabled["i__INSTANCE__"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-__TYPE__-i__INSTANCE__-v0"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-__TYPE__"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena___TYPE___i__INSTANCE___av0" {
  device_name = "/dev/sdd"
  volume_id = "${aws_ebs_volume.upena___TYPE___i__INSTANCE___v0.id}"
  instance_id = "${aws_instance.upena___TYPE___i__INSTANCE__.id}"
  force_detach = true
  count = "${var.upena___TYPE___enabled["i__INSTANCE__"]}"
}

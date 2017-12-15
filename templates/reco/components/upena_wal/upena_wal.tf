
variable "upena_keypair" {
  description = "keypair"
}

variable "aws_account_short_name" {
  description = "The short name of the AWS account"
}

variable "region" {
  description = "separates upena cluster in the same account"
}

variable "upena_wal_ami" {
  description = "ami to be used for upena_wal instances"
}

variable "upena_wal_instance_ebs_optimized" {
  description = "ebs_optimized"
  default = "false"
}

variable "upena_wal_volume_size" {
  description = "size of the EBS volume attached to the upena_wal instances"
}

variable "upena_wal_volume_type" {
  description = "type of the EBS volume attached to the upena_wal instances"
  default = "st1"
}
variable "upena_wal_enabled" {
    description = ""
    default = {
i1 = "0"
i1_bootstrap = "./bootstrap_provision.sh"
i1_az = ""
i1_subnet_key = ""
i1_v1 = "0"
i1_v2 = "0"
i1_v3 = "0"
i2 = "0"
i2_bootstrap = "./bootstrap_provision.sh"
i2_az = ""
i2_subnet_key = ""
i2_v1 = "0"
i2_v2 = "0"
i2_v3 = "0"
i3 = "0"
i3_bootstrap = "./bootstrap_provision.sh"
i3_az = ""
i3_subnet_key = ""
i3_v1 = "0"
i3_v2 = "0"
i3_v3 = "0"
i4 = "0"
i4_bootstrap = "./bootstrap_provision.sh"
i4_az = ""
i4_subnet_key = ""
i4_v1 = "0"
i4_v2 = "0"
i4_v3 = "0"
i5 = "0"
i5_bootstrap = "./bootstrap_provision.sh"
i5_az = ""
i5_subnet_key = ""
i5_v1 = "0"
i5_v2 = "0"
i5_v3 = "0"
i6 = "0"
i6_bootstrap = "./bootstrap_provision.sh"
i6_az = ""
i6_subnet_key = ""
i6_v1 = "0"
i6_v2 = "0"
i6_v3 = "0"
i7 = "0"
i7_bootstrap = "./bootstrap_provision.sh"
i7_az = ""
i7_subnet_key = ""
i7_v1 = "0"
i7_v2 = "0"
i7_v3 = "0"
i8 = "0"
i8_bootstrap = "./bootstrap_provision.sh"
i8_az = ""
i8_subnet_key = ""
i8_v1 = "0"
i8_v2 = "0"
i8_v3 = "0"
i9 = "0"
i9_bootstrap = "./bootstrap_provision.sh"
i9_az = ""
i9_subnet_key = ""
i9_v1 = "0"
i9_v2 = "0"
i9_v3 = "0"
    }
}

#----------------------------------------------------------------------------------------
# Instance 1
#----------------------------------------------------------------------------------------

resource "aws_instance" "upena_wal_i1" {
  count = "${var.upena_wal_enabled["i1"]}"
  ami = "${var.upena_wal_ami}"
  instance_type = "${var.upena_wal_enabled["i1_instance_type"]}"
  ebs_optimized = "${var.upena_wal_instance_ebs_optimized}"
  availability_zone = "${var.upena_wal_enabled["i1_az"]}"
  key_name = "${var.upena_keypair}"
  iam_instance_profile = "${var.aws_iam_instance_profile_upena}"
  vpc_security_group_ids = [
    "${aws_security_group.upena_wal_sg.id}",
    "${var.aws_security_group_env_instance}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${var.upena_wal_enabled["i1_subnet_key"]}")}"

  root_block_device = {
    volume_type = "standard"
    volume_size = "8"
  }

  user_data = "${format(file(var.upena_wal_enabled["i1_bootstrap"]), "${var.region}-${var.aws_account_short_name}-${var.upena_s3_bucket}")}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i1"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_record" "newpena_wal_ri1" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i1"
  type = "A"
  ttl = "60"
  records = [
    "${aws_instance.upena_wal_i1.private_ip}"
  ]
  count = "${var.upena_wal_enabled["i1"]}"
}

resource "aws_ebs_volume" "upena_wal_i1_v0" {
  availability_zone = "${var.upena_wal_enabled["i1_az"]}"
  encrypted = true
  size = "500"
  type = "st1"
  count = "${var.upena_wal_enabled["i1"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i1-v0"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i1_av0" {
  device_name = "/dev/sdd"
  volume_id = "${aws_ebs_volume.upena_wal_i1_v0.id}"
  instance_id = "${aws_instance.upena_wal_i1.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i1"]}"
}

#----------------------------------------------------------------------------------------
# Instance 1 Volume 1
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i1_v1" {
  availability_zone = "${var.upena_wal_enabled["i1_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i1_v1"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i1-v1"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i1_av1" {
  device_name = "/dev/sde"
  volume_id = "${aws_ebs_volume.upena_wal_i1_v1.id}"
  instance_id = "${aws_instance.upena_wal_i1.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i1_v1"]}"
}

#----------------------------------------------------------------------------------------
# Instance 1 Volume 2
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i1_v2" {
  availability_zone = "${var.upena_wal_enabled["i1_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i1_v2"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i1-v2"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i1_av2" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.upena_wal_i1_v2.id}"
  instance_id = "${aws_instance.upena_wal_i1.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i1_v2"]}"
}

#----------------------------------------------------------------------------------------
# Instance 1 Volume 3
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i1_v3" {
  availability_zone = "${var.upena_wal_enabled["i1_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i1_v3"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i1-v3"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i1_av3" {
  device_name = "/dev/sdg"
  volume_id = "${aws_ebs_volume.upena_wal_i1_v3.id}"
  instance_id = "${aws_instance.upena_wal_i1.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i1_v3"]}"
}

#----------------------------------------------------------------------------------------
# Instance 2
#----------------------------------------------------------------------------------------

resource "aws_instance" "upena_wal_i2" {
  count = "${var.upena_wal_enabled["i2"]}"
  ami = "${var.upena_wal_ami}"
  instance_type = "${var.upena_wal_enabled["i2_instance_type"]}"
  ebs_optimized = "${var.upena_wal_instance_ebs_optimized}"
  availability_zone = "${var.upena_wal_enabled["i2_az"]}"
  key_name = "${var.upena_keypair}"
  iam_instance_profile = "${var.aws_iam_instance_profile_upena}"
  vpc_security_group_ids = [
    "${aws_security_group.upena_wal_sg.id}",
    "${var.aws_security_group_env_instance}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${var.upena_wal_enabled["i2_subnet_key"]}")}"

  root_block_device = {
    volume_type = "standard"
    volume_size = "8"
  }

  user_data = "${format(file(var.upena_wal_enabled["i2_bootstrap"]), "${var.region}-${var.aws_account_short_name}-${var.upena_s3_bucket}")}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i2"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_record" "newpena_wal_ri2" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i2"
  type = "A"
  ttl = "60"
  records = [
    "${aws_instance.upena_wal_i2.private_ip}"
  ]
  count = "${var.upena_wal_enabled["i2"]}"
}

resource "aws_ebs_volume" "upena_wal_i2_v0" {
  availability_zone = "${var.upena_wal_enabled["i2_az"]}"
  encrypted = true
  size = "500"
  type = "st1"
  count = "${var.upena_wal_enabled["i2"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i2-v0"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i2_av0" {
  device_name = "/dev/sdd"
  volume_id = "${aws_ebs_volume.upena_wal_i2_v0.id}"
  instance_id = "${aws_instance.upena_wal_i2.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i2"]}"
}

#----------------------------------------------------------------------------------------
# Instance 2 Volume 1
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i2_v1" {
  availability_zone = "${var.upena_wal_enabled["i2_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i2_v1"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i2-v1"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i2_av1" {
  device_name = "/dev/sde"
  volume_id = "${aws_ebs_volume.upena_wal_i2_v1.id}"
  instance_id = "${aws_instance.upena_wal_i2.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i2_v1"]}"
}

#----------------------------------------------------------------------------------------
# Instance 2 Volume 2
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i2_v2" {
  availability_zone = "${var.upena_wal_enabled["i2_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i2_v2"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i2-v2"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i2_av2" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.upena_wal_i2_v2.id}"
  instance_id = "${aws_instance.upena_wal_i2.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i2_v2"]}"
}

#----------------------------------------------------------------------------------------
# Instance 2 Volume 3
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i2_v3" {
  availability_zone = "${var.upena_wal_enabled["i2_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i2_v3"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i2-v3"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i2_av3" {
  device_name = "/dev/sdg"
  volume_id = "${aws_ebs_volume.upena_wal_i2_v3.id}"
  instance_id = "${aws_instance.upena_wal_i2.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i2_v3"]}"
}

#----------------------------------------------------------------------------------------
# Instance 3
#----------------------------------------------------------------------------------------

resource "aws_instance" "upena_wal_i3" {
  count = "${var.upena_wal_enabled["i3"]}"
  ami = "${var.upena_wal_ami}"
  instance_type = "${var.upena_wal_enabled["i3_instance_type"]}"
  ebs_optimized = "${var.upena_wal_instance_ebs_optimized}"
  availability_zone = "${var.upena_wal_enabled["i3_az"]}"
  key_name = "${var.upena_keypair}"
  iam_instance_profile = "${var.aws_iam_instance_profile_upena}"
  vpc_security_group_ids = [
    "${aws_security_group.upena_wal_sg.id}",
    "${var.aws_security_group_env_instance}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${var.upena_wal_enabled["i3_subnet_key"]}")}"

  root_block_device = {
    volume_type = "standard"
    volume_size = "8"
  }

  user_data = "${format(file(var.upena_wal_enabled["i3_bootstrap"]), "${var.region}-${var.aws_account_short_name}-${var.upena_s3_bucket}")}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i3"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_record" "newpena_wal_ri3" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i3"
  type = "A"
  ttl = "60"
  records = [
    "${aws_instance.upena_wal_i3.private_ip}"
  ]
  count = "${var.upena_wal_enabled["i3"]}"
}

resource "aws_ebs_volume" "upena_wal_i3_v0" {
  availability_zone = "${var.upena_wal_enabled["i3_az"]}"
  encrypted = true
  size = "500"
  type = "st1"
  count = "${var.upena_wal_enabled["i3"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i3-v0"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i3_av0" {
  device_name = "/dev/sdd"
  volume_id = "${aws_ebs_volume.upena_wal_i3_v0.id}"
  instance_id = "${aws_instance.upena_wal_i3.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i3"]}"
}

#----------------------------------------------------------------------------------------
# Instance 3 Volume 1
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i3_v1" {
  availability_zone = "${var.upena_wal_enabled["i3_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i3_v1"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i3-v1"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i3_av1" {
  device_name = "/dev/sde"
  volume_id = "${aws_ebs_volume.upena_wal_i3_v1.id}"
  instance_id = "${aws_instance.upena_wal_i3.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i3_v1"]}"
}

#----------------------------------------------------------------------------------------
# Instance 3 Volume 2
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i3_v2" {
  availability_zone = "${var.upena_wal_enabled["i3_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i3_v2"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i3-v2"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i3_av2" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.upena_wal_i3_v2.id}"
  instance_id = "${aws_instance.upena_wal_i3.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i3_v2"]}"
}

#----------------------------------------------------------------------------------------
# Instance 3 Volume 3
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i3_v3" {
  availability_zone = "${var.upena_wal_enabled["i3_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i3_v3"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i3-v3"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i3_av3" {
  device_name = "/dev/sdg"
  volume_id = "${aws_ebs_volume.upena_wal_i3_v3.id}"
  instance_id = "${aws_instance.upena_wal_i3.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i3_v3"]}"
}

#----------------------------------------------------------------------------------------
# Instance 4
#----------------------------------------------------------------------------------------

resource "aws_instance" "upena_wal_i4" {
  count = "${var.upena_wal_enabled["i4"]}"
  ami = "${var.upena_wal_ami}"
  instance_type = "${var.upena_wal_enabled["i4_instance_type"]}"
  ebs_optimized = "${var.upena_wal_instance_ebs_optimized}"
  availability_zone = "${var.upena_wal_enabled["i4_az"]}"
  key_name = "${var.upena_keypair}"
  iam_instance_profile = "${var.aws_iam_instance_profile_upena}"
  vpc_security_group_ids = [
    "${aws_security_group.upena_wal_sg.id}",
    "${var.aws_security_group_env_instance}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${var.upena_wal_enabled["i4_subnet_key"]}")}"

  root_block_device = {
    volume_type = "standard"
    volume_size = "8"
  }

  user_data = "${format(file(var.upena_wal_enabled["i4_bootstrap"]), "${var.region}-${var.aws_account_short_name}-${var.upena_s3_bucket}")}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i4"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_record" "newpena_wal_ri4" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i4"
  type = "A"
  ttl = "60"
  records = [
    "${aws_instance.upena_wal_i4.private_ip}"
  ]
  count = "${var.upena_wal_enabled["i4"]}"
}

resource "aws_ebs_volume" "upena_wal_i4_v0" {
  availability_zone = "${var.upena_wal_enabled["i4_az"]}"
  encrypted = true
  size = "500"
  type = "st1"
  count = "${var.upena_wal_enabled["i4"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i4-v0"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i4_av0" {
  device_name = "/dev/sdd"
  volume_id = "${aws_ebs_volume.upena_wal_i4_v0.id}"
  instance_id = "${aws_instance.upena_wal_i4.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i4"]}"
}

#----------------------------------------------------------------------------------------
# Instance 4 Volume 1
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i4_v1" {
  availability_zone = "${var.upena_wal_enabled["i4_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i4_v1"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i4-v1"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i4_av1" {
  device_name = "/dev/sde"
  volume_id = "${aws_ebs_volume.upena_wal_i4_v1.id}"
  instance_id = "${aws_instance.upena_wal_i4.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i4_v1"]}"
}

#----------------------------------------------------------------------------------------
# Instance 4 Volume 2
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i4_v2" {
  availability_zone = "${var.upena_wal_enabled["i4_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i4_v2"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i4-v2"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i4_av2" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.upena_wal_i4_v2.id}"
  instance_id = "${aws_instance.upena_wal_i4.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i4_v2"]}"
}

#----------------------------------------------------------------------------------------
# Instance 4 Volume 3
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i4_v3" {
  availability_zone = "${var.upena_wal_enabled["i4_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i4_v3"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i4-v3"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i4_av3" {
  device_name = "/dev/sdg"
  volume_id = "${aws_ebs_volume.upena_wal_i4_v3.id}"
  instance_id = "${aws_instance.upena_wal_i4.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i4_v3"]}"
}

#----------------------------------------------------------------------------------------
# Instance 5
#----------------------------------------------------------------------------------------

resource "aws_instance" "upena_wal_i5" {
  count = "${var.upena_wal_enabled["i5"]}"
  ami = "${var.upena_wal_ami}"
  instance_type = "${var.upena_wal_enabled["i5_instance_type"]}"
  ebs_optimized = "${var.upena_wal_instance_ebs_optimized}"
  availability_zone = "${var.upena_wal_enabled["i5_az"]}"
  key_name = "${var.upena_keypair}"
  iam_instance_profile = "${var.aws_iam_instance_profile_upena}"
  vpc_security_group_ids = [
    "${aws_security_group.upena_wal_sg.id}",
    "${var.aws_security_group_env_instance}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${var.upena_wal_enabled["i5_subnet_key"]}")}"

  root_block_device = {
    volume_type = "standard"
    volume_size = "8"
  }

  user_data = "${format(file(var.upena_wal_enabled["i5_bootstrap"]), "${var.region}-${var.aws_account_short_name}-${var.upena_s3_bucket}")}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i5"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_record" "newpena_wal_ri5" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i5"
  type = "A"
  ttl = "60"
  records = [
    "${aws_instance.upena_wal_i5.private_ip}"
  ]
  count = "${var.upena_wal_enabled["i5"]}"
}

resource "aws_ebs_volume" "upena_wal_i5_v0" {
  availability_zone = "${var.upena_wal_enabled["i5_az"]}"
  encrypted = true
  size = "500"
  type = "st1"
  count = "${var.upena_wal_enabled["i5"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i5-v0"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i5_av0" {
  device_name = "/dev/sdd"
  volume_id = "${aws_ebs_volume.upena_wal_i5_v0.id}"
  instance_id = "${aws_instance.upena_wal_i5.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i5"]}"
}

#----------------------------------------------------------------------------------------
# Instance 5 Volume 1
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i5_v1" {
  availability_zone = "${var.upena_wal_enabled["i5_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i5_v1"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i5-v1"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i5_av1" {
  device_name = "/dev/sde"
  volume_id = "${aws_ebs_volume.upena_wal_i5_v1.id}"
  instance_id = "${aws_instance.upena_wal_i5.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i5_v1"]}"
}

#----------------------------------------------------------------------------------------
# Instance 5 Volume 2
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i5_v2" {
  availability_zone = "${var.upena_wal_enabled["i5_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i5_v2"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i5-v2"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i5_av2" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.upena_wal_i5_v2.id}"
  instance_id = "${aws_instance.upena_wal_i5.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i5_v2"]}"
}

#----------------------------------------------------------------------------------------
# Instance 5 Volume 3
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i5_v3" {
  availability_zone = "${var.upena_wal_enabled["i5_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i5_v3"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i5-v3"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i5_av3" {
  device_name = "/dev/sdg"
  volume_id = "${aws_ebs_volume.upena_wal_i5_v3.id}"
  instance_id = "${aws_instance.upena_wal_i5.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i5_v3"]}"
}

#----------------------------------------------------------------------------------------
# Instance 6
#----------------------------------------------------------------------------------------

resource "aws_instance" "upena_wal_i6" {
  count = "${var.upena_wal_enabled["i6"]}"
  ami = "${var.upena_wal_ami}"
  instance_type = "${var.upena_wal_enabled["i6_instance_type"]}"
  ebs_optimized = "${var.upena_wal_instance_ebs_optimized}"
  availability_zone = "${var.upena_wal_enabled["i6_az"]}"
  key_name = "${var.upena_keypair}"
  iam_instance_profile = "${var.aws_iam_instance_profile_upena}"
  vpc_security_group_ids = [
    "${aws_security_group.upena_wal_sg.id}",
    "${var.aws_security_group_env_instance}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${var.upena_wal_enabled["i6_subnet_key"]}")}"

  root_block_device = {
    volume_type = "standard"
    volume_size = "8"
  }

  user_data = "${format(file(var.upena_wal_enabled["i6_bootstrap"]), "${var.region}-${var.aws_account_short_name}-${var.upena_s3_bucket}")}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i6"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_record" "newpena_wal_ri6" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i6"
  type = "A"
  ttl = "60"
  records = [
    "${aws_instance.upena_wal_i6.private_ip}"
  ]
  count = "${var.upena_wal_enabled["i6"]}"
}

resource "aws_ebs_volume" "upena_wal_i6_v0" {
  availability_zone = "${var.upena_wal_enabled["i6_az"]}"
  encrypted = true
  size = "500"
  type = "st1"
  count = "${var.upena_wal_enabled["i6"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i6-v0"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i6_av0" {
  device_name = "/dev/sdd"
  volume_id = "${aws_ebs_volume.upena_wal_i6_v0.id}"
  instance_id = "${aws_instance.upena_wal_i6.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i6"]}"
}

#----------------------------------------------------------------------------------------
# Instance 6 Volume 1
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i6_v1" {
  availability_zone = "${var.upena_wal_enabled["i6_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i6_v1"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i6-v1"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i6_av1" {
  device_name = "/dev/sde"
  volume_id = "${aws_ebs_volume.upena_wal_i6_v1.id}"
  instance_id = "${aws_instance.upena_wal_i6.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i6_v1"]}"
}

#----------------------------------------------------------------------------------------
# Instance 6 Volume 2
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i6_v2" {
  availability_zone = "${var.upena_wal_enabled["i6_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i6_v2"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i6-v2"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i6_av2" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.upena_wal_i6_v2.id}"
  instance_id = "${aws_instance.upena_wal_i6.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i6_v2"]}"
}

#----------------------------------------------------------------------------------------
# Instance 6 Volume 3
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i6_v3" {
  availability_zone = "${var.upena_wal_enabled["i6_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i6_v3"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i6-v3"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i6_av3" {
  device_name = "/dev/sdg"
  volume_id = "${aws_ebs_volume.upena_wal_i6_v3.id}"
  instance_id = "${aws_instance.upena_wal_i6.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i6_v3"]}"
}

#----------------------------------------------------------------------------------------
# Instance 7
#----------------------------------------------------------------------------------------

resource "aws_instance" "upena_wal_i7" {
  count = "${var.upena_wal_enabled["i7"]}"
  ami = "${var.upena_wal_ami}"
  instance_type = "${var.upena_wal_enabled["i7_instance_type"]}"
  ebs_optimized = "${var.upena_wal_instance_ebs_optimized}"
  availability_zone = "${var.upena_wal_enabled["i7_az"]}"
  key_name = "${var.upena_keypair}"
  iam_instance_profile = "${var.aws_iam_instance_profile_upena}"
  vpc_security_group_ids = [
    "${aws_security_group.upena_wal_sg.id}",
    "${var.aws_security_group_env_instance}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${var.upena_wal_enabled["i7_subnet_key"]}")}"

  root_block_device = {
    volume_type = "standard"
    volume_size = "8"
  }

  user_data = "${format(file(var.upena_wal_enabled["i7_bootstrap"]), "${var.region}-${var.aws_account_short_name}-${var.upena_s3_bucket}")}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i7"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_record" "newpena_wal_ri7" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i7"
  type = "A"
  ttl = "60"
  records = [
    "${aws_instance.upena_wal_i7.private_ip}"
  ]
  count = "${var.upena_wal_enabled["i7"]}"
}

resource "aws_ebs_volume" "upena_wal_i7_v0" {
  availability_zone = "${var.upena_wal_enabled["i7_az"]}"
  encrypted = true
  size = "500"
  type = "st1"
  count = "${var.upena_wal_enabled["i7"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i7-v0"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i7_av0" {
  device_name = "/dev/sdd"
  volume_id = "${aws_ebs_volume.upena_wal_i7_v0.id}"
  instance_id = "${aws_instance.upena_wal_i7.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i7"]}"
}

#----------------------------------------------------------------------------------------
# Instance 7 Volume 1
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i7_v1" {
  availability_zone = "${var.upena_wal_enabled["i7_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i7_v1"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i7-v1"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i7_av1" {
  device_name = "/dev/sde"
  volume_id = "${aws_ebs_volume.upena_wal_i7_v1.id}"
  instance_id = "${aws_instance.upena_wal_i7.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i7_v1"]}"
}

#----------------------------------------------------------------------------------------
# Instance 7 Volume 2
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i7_v2" {
  availability_zone = "${var.upena_wal_enabled["i7_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i7_v2"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i7-v2"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i7_av2" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.upena_wal_i7_v2.id}"
  instance_id = "${aws_instance.upena_wal_i7.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i7_v2"]}"
}

#----------------------------------------------------------------------------------------
# Instance 7 Volume 3
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i7_v3" {
  availability_zone = "${var.upena_wal_enabled["i7_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i7_v3"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i7-v3"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i7_av3" {
  device_name = "/dev/sdg"
  volume_id = "${aws_ebs_volume.upena_wal_i7_v3.id}"
  instance_id = "${aws_instance.upena_wal_i7.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i7_v3"]}"
}

#----------------------------------------------------------------------------------------
# Instance 8
#----------------------------------------------------------------------------------------

resource "aws_instance" "upena_wal_i8" {
  count = "${var.upena_wal_enabled["i8"]}"
  ami = "${var.upena_wal_ami}"
  instance_type = "${var.upena_wal_enabled["i8_instance_type"]}"
  ebs_optimized = "${var.upena_wal_instance_ebs_optimized}"
  availability_zone = "${var.upena_wal_enabled["i8_az"]}"
  key_name = "${var.upena_keypair}"
  iam_instance_profile = "${var.aws_iam_instance_profile_upena}"
  vpc_security_group_ids = [
    "${aws_security_group.upena_wal_sg.id}",
    "${var.aws_security_group_env_instance}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${var.upena_wal_enabled["i8_subnet_key"]}")}"

  root_block_device = {
    volume_type = "standard"
    volume_size = "8"
  }

  user_data = "${format(file(var.upena_wal_enabled["i8_bootstrap"]), "${var.region}-${var.aws_account_short_name}-${var.upena_s3_bucket}")}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i8"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_record" "newpena_wal_ri8" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i8"
  type = "A"
  ttl = "60"
  records = [
    "${aws_instance.upena_wal_i8.private_ip}"
  ]
  count = "${var.upena_wal_enabled["i8"]}"
}

resource "aws_ebs_volume" "upena_wal_i8_v0" {
  availability_zone = "${var.upena_wal_enabled["i8_az"]}"
  encrypted = true
  size = "500"
  type = "st1"
  count = "${var.upena_wal_enabled["i8"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i8-v0"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i8_av0" {
  device_name = "/dev/sdd"
  volume_id = "${aws_ebs_volume.upena_wal_i8_v0.id}"
  instance_id = "${aws_instance.upena_wal_i8.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i8"]}"
}

#----------------------------------------------------------------------------------------
# Instance 8 Volume 1
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i8_v1" {
  availability_zone = "${var.upena_wal_enabled["i8_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i8_v1"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i8-v1"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i8_av1" {
  device_name = "/dev/sde"
  volume_id = "${aws_ebs_volume.upena_wal_i8_v1.id}"
  instance_id = "${aws_instance.upena_wal_i8.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i8_v1"]}"
}

#----------------------------------------------------------------------------------------
# Instance 8 Volume 2
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i8_v2" {
  availability_zone = "${var.upena_wal_enabled["i8_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i8_v2"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i8-v2"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i8_av2" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.upena_wal_i8_v2.id}"
  instance_id = "${aws_instance.upena_wal_i8.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i8_v2"]}"
}

#----------------------------------------------------------------------------------------
# Instance 8 Volume 3
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i8_v3" {
  availability_zone = "${var.upena_wal_enabled["i8_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i8_v3"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i8-v3"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i8_av3" {
  device_name = "/dev/sdg"
  volume_id = "${aws_ebs_volume.upena_wal_i8_v3.id}"
  instance_id = "${aws_instance.upena_wal_i8.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i8_v3"]}"
}

#----------------------------------------------------------------------------------------
# Instance 9
#----------------------------------------------------------------------------------------

resource "aws_instance" "upena_wal_i9" {
  count = "${var.upena_wal_enabled["i9"]}"
  ami = "${var.upena_wal_ami}"
  instance_type = "${var.upena_wal_enabled["i9_instance_type"]}"
  ebs_optimized = "${var.upena_wal_instance_ebs_optimized}"
  availability_zone = "${var.upena_wal_enabled["i9_az"]}"
  key_name = "${var.upena_keypair}"
  iam_instance_profile = "${var.aws_iam_instance_profile_upena}"
  vpc_security_group_ids = [
    "${aws_security_group.upena_wal_sg.id}",
    "${var.aws_security_group_env_instance}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${var.upena_wal_enabled["i9_subnet_key"]}")}"

  root_block_device = {
    volume_type = "standard"
    volume_size = "8"
  }

  user_data = "${format(file(var.upena_wal_enabled["i9_bootstrap"]), "${var.region}-${var.aws_account_short_name}-${var.upena_s3_bucket}")}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i9"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_record" "newpena_wal_ri9" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i9"
  type = "A"
  ttl = "60"
  records = [
    "${aws_instance.upena_wal_i9.private_ip}"
  ]
  count = "${var.upena_wal_enabled["i9"]}"
}

resource "aws_ebs_volume" "upena_wal_i9_v0" {
  availability_zone = "${var.upena_wal_enabled["i9_az"]}"
  encrypted = true
  size = "500"
  type = "st1"
  count = "${var.upena_wal_enabled["i9"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i9-v0"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i9_av0" {
  device_name = "/dev/sdd"
  volume_id = "${aws_ebs_volume.upena_wal_i9_v0.id}"
  instance_id = "${aws_instance.upena_wal_i9.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i9"]}"
}

#----------------------------------------------------------------------------------------
# Instance 9 Volume 1
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i9_v1" {
  availability_zone = "${var.upena_wal_enabled["i9_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i9_v1"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i9-v1"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i9_av1" {
  device_name = "/dev/sde"
  volume_id = "${aws_ebs_volume.upena_wal_i9_v1.id}"
  instance_id = "${aws_instance.upena_wal_i9.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i9_v1"]}"
}

#----------------------------------------------------------------------------------------
# Instance 9 Volume 2
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i9_v2" {
  availability_zone = "${var.upena_wal_enabled["i9_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i9_v2"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i9-v2"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i9_av2" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.upena_wal_i9_v2.id}"
  instance_id = "${aws_instance.upena_wal_i9.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i9_v2"]}"
}

#----------------------------------------------------------------------------------------
# Instance 9 Volume 3
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_wal_i9_v3" {
  availability_zone = "${var.upena_wal_enabled["i9_az"]}"
  encrypted = true
  size = "${var.upena_wal_volume_size}"
  type = "${var.upena_wal_volume_type}"
  count = "${var.upena_wal_enabled["i9_v3"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-wal-i9-v3"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-wal"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_wal_i9_av3" {
  device_name = "/dev/sdg"
  volume_id = "${aws_ebs_volume.upena_wal_i9_v3.id}"
  instance_id = "${aws_instance.upena_wal_i9.id}"
  force_detach = true
  count = "${var.upena_wal_enabled["i9_v3"]}"
}

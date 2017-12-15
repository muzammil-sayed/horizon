
variable "upena_keypair" {
  description = "keypair"
}

variable "aws_account_short_name" {
  description = "The short name of the AWS account"
}

variable "region" {
  description = "separates upena cluster in the same account"
}

variable "upena_api_ami" {
  description = "ami to be used for upena_api instances"
}

variable "upena_api_instance_ebs_optimized" {
  description = "ebs_optimized"
  default = "false"
}

variable "upena_api_volume_size" {
  description = "size of the EBS volume attached to the upena_api instances"
}

variable "upena_api_volume_type" {
  description = "type of the EBS volume attached to the upena_api instances"
  default = "st1"
}
variable "upena_api_enabled" {
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
    }
}

#----------------------------------------------------------------------------------------
# Instance 1
#----------------------------------------------------------------------------------------

resource "aws_instance" "upena_api_i1" {
  count = "${var.upena_api_enabled["i1"]}"
  ami = "${var.upena_api_ami}"
  instance_type = "${var.upena_api_enabled["i1_instance_type"]}"
  ebs_optimized = "${var.upena_api_instance_ebs_optimized}"
  availability_zone = "${var.upena_api_enabled["i1_az"]}"
  key_name = "${var.upena_keypair}"
  iam_instance_profile = "${var.aws_iam_instance_profile_upena}"
  vpc_security_group_ids = [
    "${aws_security_group.upena_api_sg.id}",
    "${var.aws_security_group_env_instance}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${var.upena_api_enabled["i1_subnet_key"]}")}"

  root_block_device = {
    volume_type = "standard"
    volume_size = "8"
  }

  user_data = "${format(file(var.upena_api_enabled["i1_bootstrap"]), "${var.region}-${var.aws_account_short_name}-${var.upena_s3_bucket}")}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-api-i1"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-api"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_record" "newpena_api_ri1" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.region}-${var.aws_account_short_name}-newpena-api-i1"
  type = "A"
  ttl = "60"
  records = [
    "${aws_instance.upena_api_i1.private_ip}"
  ]
  count = "${var.upena_api_enabled["i1"]}"
}

resource "aws_ebs_volume" "upena_api_i1_v0" {
  availability_zone = "${var.upena_api_enabled["i1_az"]}"
  encrypted = true
  size = "500"
  type = "st1"
  count = "${var.upena_api_enabled["i1"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-api-i1-v0"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-api"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_api_i1_av0" {
  device_name = "/dev/sdd"
  volume_id = "${aws_ebs_volume.upena_api_i1_v0.id}"
  instance_id = "${aws_instance.upena_api_i1.id}"
  force_detach = true
  count = "${var.upena_api_enabled["i1"]}"
}

#----------------------------------------------------------------------------------------
# Instance 1 Volume 1
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_api_i1_v1" {
  availability_zone = "${var.upena_api_enabled["i1_az"]}"
  encrypted = true
  size = "${var.upena_api_volume_size}"
  type = "${var.upena_api_volume_type}"
  count = "${var.upena_api_enabled["i1_v1"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-api-i1-v1"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-api"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_api_i1_av1" {
  device_name = "/dev/sde"
  volume_id = "${aws_ebs_volume.upena_api_i1_v1.id}"
  instance_id = "${aws_instance.upena_api_i1.id}"
  force_detach = true
  count = "${var.upena_api_enabled["i1_v1"]}"
}

#----------------------------------------------------------------------------------------
# Instance 1 Volume 2
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_api_i1_v2" {
  availability_zone = "${var.upena_api_enabled["i1_az"]}"
  encrypted = true
  size = "${var.upena_api_volume_size}"
  type = "${var.upena_api_volume_type}"
  count = "${var.upena_api_enabled["i1_v2"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-api-i1-v2"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-api"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_api_i1_av2" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.upena_api_i1_v2.id}"
  instance_id = "${aws_instance.upena_api_i1.id}"
  force_detach = true
  count = "${var.upena_api_enabled["i1_v2"]}"
}

#----------------------------------------------------------------------------------------
# Instance 1 Volume 3
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_api_i1_v3" {
  availability_zone = "${var.upena_api_enabled["i1_az"]}"
  encrypted = true
  size = "${var.upena_api_volume_size}"
  type = "${var.upena_api_volume_type}"
  count = "${var.upena_api_enabled["i1_v3"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-api-i1-v3"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-api"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_api_i1_av3" {
  device_name = "/dev/sdg"
  volume_id = "${aws_ebs_volume.upena_api_i1_v3.id}"
  instance_id = "${aws_instance.upena_api_i1.id}"
  force_detach = true
  count = "${var.upena_api_enabled["i1_v3"]}"
}

#----------------------------------------------------------------------------------------
# Instance 2
#----------------------------------------------------------------------------------------

resource "aws_instance" "upena_api_i2" {
  count = "${var.upena_api_enabled["i2"]}"
  ami = "${var.upena_api_ami}"
  instance_type = "${var.upena_api_enabled["i2_instance_type"]}"
  ebs_optimized = "${var.upena_api_instance_ebs_optimized}"
  availability_zone = "${var.upena_api_enabled["i2_az"]}"
  key_name = "${var.upena_keypair}"
  iam_instance_profile = "${var.aws_iam_instance_profile_upena}"
  vpc_security_group_ids = [
    "${aws_security_group.upena_api_sg.id}",
    "${var.aws_security_group_env_instance}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${var.upena_api_enabled["i2_subnet_key"]}")}"

  root_block_device = {
    volume_type = "standard"
    volume_size = "8"
  }

  user_data = "${format(file(var.upena_api_enabled["i2_bootstrap"]), "${var.region}-${var.aws_account_short_name}-${var.upena_s3_bucket}")}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-api-i2"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-api"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_record" "newpena_api_ri2" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.region}-${var.aws_account_short_name}-newpena-api-i2"
  type = "A"
  ttl = "60"
  records = [
    "${aws_instance.upena_api_i2.private_ip}"
  ]
  count = "${var.upena_api_enabled["i2"]}"
}

resource "aws_ebs_volume" "upena_api_i2_v0" {
  availability_zone = "${var.upena_api_enabled["i2_az"]}"
  encrypted = true
  size = "500"
  type = "st1"
  count = "${var.upena_api_enabled["i2"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-api-i2-v0"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-api"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_api_i2_av0" {
  device_name = "/dev/sdd"
  volume_id = "${aws_ebs_volume.upena_api_i2_v0.id}"
  instance_id = "${aws_instance.upena_api_i2.id}"
  force_detach = true
  count = "${var.upena_api_enabled["i2"]}"
}

#----------------------------------------------------------------------------------------
# Instance 2 Volume 1
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_api_i2_v1" {
  availability_zone = "${var.upena_api_enabled["i2_az"]}"
  encrypted = true
  size = "${var.upena_api_volume_size}"
  type = "${var.upena_api_volume_type}"
  count = "${var.upena_api_enabled["i2_v1"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-api-i2-v1"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-api"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_api_i2_av1" {
  device_name = "/dev/sde"
  volume_id = "${aws_ebs_volume.upena_api_i2_v1.id}"
  instance_id = "${aws_instance.upena_api_i2.id}"
  force_detach = true
  count = "${var.upena_api_enabled["i2_v1"]}"
}

#----------------------------------------------------------------------------------------
# Instance 2 Volume 2
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_api_i2_v2" {
  availability_zone = "${var.upena_api_enabled["i2_az"]}"
  encrypted = true
  size = "${var.upena_api_volume_size}"
  type = "${var.upena_api_volume_type}"
  count = "${var.upena_api_enabled["i2_v2"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-api-i2-v2"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-api"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_api_i2_av2" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.upena_api_i2_v2.id}"
  instance_id = "${aws_instance.upena_api_i2.id}"
  force_detach = true
  count = "${var.upena_api_enabled["i2_v2"]}"
}

#----------------------------------------------------------------------------------------
# Instance 2 Volume 3
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_api_i2_v3" {
  availability_zone = "${var.upena_api_enabled["i2_az"]}"
  encrypted = true
  size = "${var.upena_api_volume_size}"
  type = "${var.upena_api_volume_type}"
  count = "${var.upena_api_enabled["i2_v3"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-api-i2-v3"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-api"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_api_i2_av3" {
  device_name = "/dev/sdg"
  volume_id = "${aws_ebs_volume.upena_api_i2_v3.id}"
  instance_id = "${aws_instance.upena_api_i2.id}"
  force_detach = true
  count = "${var.upena_api_enabled["i2_v3"]}"
}

#----------------------------------------------------------------------------------------
# Instance 3
#----------------------------------------------------------------------------------------

resource "aws_instance" "upena_api_i3" {
  count = "${var.upena_api_enabled["i3"]}"
  ami = "${var.upena_api_ami}"
  instance_type = "${var.upena_api_enabled["i3_instance_type"]}"
  ebs_optimized = "${var.upena_api_instance_ebs_optimized}"
  availability_zone = "${var.upena_api_enabled["i3_az"]}"
  key_name = "${var.upena_keypair}"
  iam_instance_profile = "${var.aws_iam_instance_profile_upena}"
  vpc_security_group_ids = [
    "${aws_security_group.upena_api_sg.id}",
    "${var.aws_security_group_env_instance}"]
  subnet_id = "${lookup(var.aws_subnet_natdc, "key${var.upena_api_enabled["i3_subnet_key"]}")}"

  root_block_device = {
    volume_type = "standard"
    volume_size = "8"
  }

  user_data = "${format(file(var.upena_api_enabled["i3_bootstrap"]), "${var.region}-${var.aws_account_short_name}-${var.upena_s3_bucket}")}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-api-i3"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-api"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_route53_record" "newpena_api_ri3" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.region}-${var.aws_account_short_name}-newpena-api-i3"
  type = "A"
  ttl = "60"
  records = [
    "${aws_instance.upena_api_i3.private_ip}"
  ]
  count = "${var.upena_api_enabled["i3"]}"
}

resource "aws_ebs_volume" "upena_api_i3_v0" {
  availability_zone = "${var.upena_api_enabled["i3_az"]}"
  encrypted = true
  size = "500"
  type = "st1"
  count = "${var.upena_api_enabled["i3"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-api-i3-v0"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-api"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_api_i3_av0" {
  device_name = "/dev/sdd"
  volume_id = "${aws_ebs_volume.upena_api_i3_v0.id}"
  instance_id = "${aws_instance.upena_api_i3.id}"
  force_detach = true
  count = "${var.upena_api_enabled["i3"]}"
}

#----------------------------------------------------------------------------------------
# Instance 3 Volume 1
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_api_i3_v1" {
  availability_zone = "${var.upena_api_enabled["i3_az"]}"
  encrypted = true
  size = "${var.upena_api_volume_size}"
  type = "${var.upena_api_volume_type}"
  count = "${var.upena_api_enabled["i3_v1"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-api-i3-v1"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-api"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_api_i3_av1" {
  device_name = "/dev/sde"
  volume_id = "${aws_ebs_volume.upena_api_i3_v1.id}"
  instance_id = "${aws_instance.upena_api_i3.id}"
  force_detach = true
  count = "${var.upena_api_enabled["i3_v1"]}"
}

#----------------------------------------------------------------------------------------
# Instance 3 Volume 2
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_api_i3_v2" {
  availability_zone = "${var.upena_api_enabled["i3_az"]}"
  encrypted = true
  size = "${var.upena_api_volume_size}"
  type = "${var.upena_api_volume_type}"
  count = "${var.upena_api_enabled["i3_v2"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-api-i3-v2"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-api"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_api_i3_av2" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.upena_api_i3_v2.id}"
  instance_id = "${aws_instance.upena_api_i3.id}"
  force_detach = true
  count = "${var.upena_api_enabled["i3_v2"]}"
}

#----------------------------------------------------------------------------------------
# Instance 3 Volume 3
#----------------------------------------------------------------------------------------

resource "aws_ebs_volume" "upena_api_i3_v3" {
  availability_zone = "${var.upena_api_enabled["i3_az"]}"
  encrypted = true
  size = "${var.upena_api_volume_size}"
  type = "${var.upena_api_volume_type}"
  count = "${var.upena_api_enabled["i3_v3"]}"

  tags {
    Name = "${var.region}-${var.aws_account_short_name}-newpena-api-i3-v3"
    Pipeline_phase = "${var.env}"
    Jive_service = "${var.jive_service}"
    Service_component = "upena-api"
    Region = "${var.region}"
    SLA = "${var.sla}"
    Account_name = "${var.aws_account_short_name}"
  }
}

resource "aws_volume_attachment" "upena_api_i3_av3" {
  device_name = "/dev/sdg"
  volume_id = "${aws_ebs_volume.upena_api_i3_v3.id}"
  instance_id = "${aws_instance.upena_api_i3.id}"
  force_detach = true
  count = "${var.upena_api_enabled["i3_v3"]}"
}

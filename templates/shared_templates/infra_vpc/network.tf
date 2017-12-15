### VPC ###
resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr["vpc"]}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name           = "${var.env}-vpc"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name           = "${var.env}-igw"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_eip" "natgw" {
  vpc   = true
  count = "${var.az_count}"

}

resource "aws_nat_gateway" "natgw" {
  allocation_id = "${element(aws_eip.natgw.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  depends_on    = ["aws_internet_gateway.igw"]
  count         = "${var.az_count}"
}

### NATDC Subnets ###

resource "aws_route_table" "natdc" {
  vpc_id = "${aws_vpc.main.id}"
  count  = "${var.az_count}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.natgw.*.id, count.index)}"
  }

  propagating_vgws = ["${aws_vpn_gateway.vgw.id}"]

  lifecycle {
    ignore_changes = ["route"]
  }

  tags {
    Name           = "${var.env}-natdc-routetable"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_subnet" "natdc" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${lookup(var.cidr, "natdc-subnet-${count.index+1}")}"
  availability_zone = "${var.region}${lookup(var.az, "az${count.index+1}")}"
  count             = "${var.az_count}"

  tags {
    Name           = "${var.env}-natdc-subnet"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_route_table_association" "natdc" {
  subnet_id      = "${element(aws_subnet.natdc.*.id, count.index+1)}"
  route_table_id = "${element(aws_route_table.natdc.*.id, count.index)}"
  count          = "${var.az_count}"
}

### Public Subnets ###

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  lifecycle {
    ignore_changes = ["route"]
  }

  tags {
    Name           = "${var.env}-public-routetable"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${lookup(var.cidr, "public-subnet-${count.index+1}")}"
  availability_zone = "${var.region}${lookup(var.az, "az${count.index+1}")}"
  count             = "${var.az_count}"

  tags {
    Name           = "${var.env}-public-subnet"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
  count          = "${var.az_count}"
}

### Private Subnets ###

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"

  lifecycle {
    ignore_changes = ["route"]
  }

  tags {
    Name           = "${var.env}-private-routetable"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${lookup(var.cidr, "private-subnet-${count.index+1}")}"
  availability_zone = "${var.region}${lookup(var.az, "az${count.index+1}")}"
  count             = "${var.az_count}"

  tags {
    Name           = "${var.env}-private-subnet"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
  count          = "${var.az_count}"
}

### Virtual Private Gateway to support Direct Connects ###
resource "aws_vpn_gateway" "vgw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name              = "${var.env}-vgw"
    pipeline_phase    = "${var.env}"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
    jive_service      = "infrastructure"
    service_component = "vpn_gateway"
  }
}

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

  route {
    cidr_block                = "${var.bastion_cidr}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.infra.id}"
  }

  propagating_vgws = ["${aws_vpn_gateway.vgw.id}"]

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
    Name                              = "${var.env}-natdc-subnet"
    pipeline_phase                    = "${var.env}"
    region                            = "${var.region}"
    sla                               = "${var.sla}"
    account_name                      = "${var.aws_account_short_name}"
    KubernetesCluster                 = "${var.region}_${var.aws_account_short_name}${var.kube_extra_id}"
    "kubernetes.io/role/internal-elb" = "${var.region}_${var.aws_account_short_name}${var.kube_extra_id}"
  }
}

resource "aws_route_table_association" "natdc" {
  subnet_id      = "${element(aws_subnet.natdc.*.id, count.index)}"
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

  route {
    cidr_block                = "${var.bastion_cidr}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.infra.id}"
  }

  tags {
    Name              = "${var.env}-public-routetable"
    pipeline_phase    = "${var.env}"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
    KubernetesCluster = "${var.region}_${var.aws_account_short_name}${var.kube_extra_id}"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${lookup(var.cidr, "public-subnet-${count.index+1}")}"
  availability_zone = "${var.region}${lookup(var.az, "az${count.index+1}")}"
  count             = "${var.az_count}"

  tags {
    Name              = "${var.env}-public-subnet"
    pipeline_phase    = "${var.env}"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
    KubernetesCluster = "${var.region}_${var.aws_account_short_name}${var.kube_extra_id}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
  count          = "${var.az_count}"
}

# Temporary hack to get additional public IP space in ms-pipeline
resource "aws_subnet" "public_addition" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${lookup(var.cidr, "public-subnet-${count.index+4}")}"
  availability_zone = "${var.region}${lookup(var.az, "az${count.index+1}")}"
  count             = "${var.extra_subnets == 1 ? var.az_count : 0}"

  tags {
    Name              = "${var.env}-public-subnet-addition"
    pipeline_phase    = "${var.env}"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
    KubernetesCluster = "${var.region}_${var.aws_account_short_name}${var.kube_extra_id}"
  }
}

resource "aws_route_table_association" "public_addition" {
  subnet_id      = "${element(aws_subnet.public_addition.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
  count          = "${var.extra_subnets == 1 ? var.az_count : 0}"
}


### Private Subnets ###

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block                = "${var.bastion_cidr}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.infra.id}"
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
  availability_zone = "${concat(var.region, lookup(var.az, concat("az", count.index+1)))}"
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

### VPC Peering with infra VPC ###

resource "aws_vpc_peering_connection" "infra" {
  peer_owner_id = "${var.aws_account_id}"
  peer_vpc_id   = "${var.infra_vpc_id}"
  vpc_id        = "${aws_vpc.main.id}"
  auto_accept   = true

  tags {
    Name           = "${var.env}_to_infra-${var.aws_account_short_name}"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

# Add peer routes to the infra VPC route tables

resource "aws_route" "infra_natdc" {
  route_table_id            = "${var.aws_route_table_natdc["key${count.index}"]}"
  destination_cidr_block    = "${var.cidr["vpc"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.infra.id}"
  count                     = "${var.az_count}"
}

resource "aws_route" "infra_public" {
  route_table_id            = "${var.aws_route_table_public}"
  destination_cidr_block    = "${var.cidr["vpc"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.infra.id}"
}

resource "aws_route" "infra_private" {
  route_table_id            = "${var.aws_route_table_private}"
  destination_cidr_block    = "${var.cidr["vpc"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.infra.id}"
}

### VGW for DirectConnect ###
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

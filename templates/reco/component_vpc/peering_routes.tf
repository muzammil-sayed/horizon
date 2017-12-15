# Individual routes created for peering connections

#####################

### Subnet: natdc ###

#####################

# Peer route for bastion

resource "aws_route" "bastion_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.bastion_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.infra.id}"
  count                     = "${var.az_count}"
}

# Peer routes to the infra VPC route tables

resource "aws_route" "infra_natdc" {
  route_table_id            = "${var.aws_route_table_natdc["key${count.index}"]}"
  destination_cidr_block    = "${var.cidr["vpc"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.infra.id}"
  count                     = "${var.az_count}"
}

# Peer route for Microservices

resource "aws_route" "microservices_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.microservices["comp_vpc_cidr"]}"
  vpc_peering_connection_id = "${var.microservices["peer_id"]}"
  count                     = "${var.condition["build_ms_reco"] == 1 ? var.az_count : 0}"
}

# Peer route for Microservices JCX

resource "aws_route" "microservices_jcx_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.microservices["jcx_comp_vpc_cidr"]}"
  vpc_peering_connection_id = "${var.microservices["jcx_peer_id"]}"
  count                     = "${var.condition["build_ms_jcx_reco"] == 1 ? var.az_count : 0}"
}

# Peer route for Data

resource "aws_route" "data_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.data["comp_vpc_cidr"]}"
  vpc_peering_connection_id = "${var.data["peer_id"]}"
  count                     = "${var.condition["build_data_reco"] == 1 ? var.az_count : 0}"
}

######################

### Subnet: public ###

######################

# Peer route for bastion

resource "aws_route" "bastion_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.bastion_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.infra.id}"
}

# Peer routes to the infra VPC route tables

resource "aws_route" "infra_public" {
  route_table_id            = "${var.aws_route_table_public}"
  destination_cidr_block    = "${var.cidr["vpc"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.infra.id}"
}

# Peer route for Microservices

resource "aws_route" "microservices_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.microservices["comp_vpc_cidr"]}"
  vpc_peering_connection_id = "${var.microservices["peer_id"]}"
  count                     = "${var.condition["build_ms_reco"]}"
}

# Peer route for Microservices JCX

resource "aws_route" "microservices_jcx_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.microservices["jcx_comp_vpc_cidr"]}"
  vpc_peering_connection_id = "${var.microservices["jcx_peer_id"]}"
  count                     = "${var.condition["build_ms_jcx_reco"]}"
}

# Peer route for Data

resource "aws_route" "data_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.data["comp_vpc_cidr"]}"
  vpc_peering_connection_id = "${var.data["peer_id"]}"
  count                     = "${var.condition["build_data_reco"]}"
}

#######################

### Subnet: private ###

#######################

# Peer route for bastion

resource "aws_route" "bastion_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.bastion_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.infra.id}"
}

# Peer routes to the infra VPC route tables

resource "aws_route" "infra_private" {
  route_table_id            = "${var.aws_route_table_private}"
  destination_cidr_block    = "${var.cidr["vpc"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.infra.id}"
}

# Peer route for Microservices

resource "aws_route" "microservices_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.microservices["comp_vpc_cidr"]}"
  vpc_peering_connection_id = "${var.microservices["peer_id"]}"
  count                     = "${var.condition["build_ms_reco"]}"
}

# Peer route for Microservices JCX

resource "aws_route" "microservices_jcx_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.microservices["jcx_comp_vpc_cidr"]}"
  vpc_peering_connection_id = "${var.microservices["jcx_peer_id"]}"
  count                     = "${var.condition["build_ms_jcx_reco"]}"
}

# Peer route for Data

resource "aws_route" "data_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.data["comp_vpc_cidr"]}"
  vpc_peering_connection_id = "${var.data["peer_id"]}"
  count                     = "${var.condition["build_data_reco"]}"
}

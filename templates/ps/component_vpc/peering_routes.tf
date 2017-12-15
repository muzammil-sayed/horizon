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

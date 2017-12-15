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

# Add peer routes to the infra VPC route tables

resource "aws_route" "infra_natdc" {
  route_table_id            = "${var.aws_route_table_natdc["key${count.index}"]}"
  destination_cidr_block    = "${var.cidr["vpc"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.infra.id}"
  count                     = "${var.az_count}"
}

# Peer routes between MS-JCX and Data account VPCs

resource "aws_route" "data_jcx_integ_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.data["comp_integ_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_jcx_integ.id}"
  count                     = "${var.condition["data_jcx_integ"] == 1 ? var.az_count : 0}"
}

resource "aws_route" "data_jcx_test_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.data["comp_test_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_jcx_test.id}"
  count                     = "${var.condition["data_jcx_test"] == 1 ? var.az_count : 0}"
}

resource "aws_route" "data_jcx_release_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.data["comp_release_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_jcx_release.id}"
  count                     = "${var.condition["data_jcx_release"] == 1 ? var.az_count : 0}"
}

resource "aws_route" "data_jcx_prod_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.data["comp_prod_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_jcx_prod.id}"
  count                     = "${var.condition["data_jcx_prod"] == 1 ? var.az_count : 0}"
}

# Peer routes between MS and Bikou account VPCs

resource "aws_route" "bikou_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.bikou["main_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.bikou.id}"
  count                     = "${var.condition["bikou"] == 1 ? var.az_count : 0}"
}

# Peer routes between MS and Data account VPCs

resource "aws_route" "data_integ_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.data["comp_integ_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_integ.id}"
  count                     = "${var.condition["data_integ"] == 1 ? var.az_count : 0}"
}

resource "aws_route" "data_test_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.data["comp_test_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_test.id}"
  count                     = "${var.condition["data_test"] == 1 ? var.az_count : 0}"
}

resource "aws_route" "data_release_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.data["comp_release_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_release.id}"
  count                     = "${var.condition["data_release"] == 1 ? var.az_count : 0}"
}

resource "aws_route" "data_brewprod_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.data["comp_brewprod_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_brewprod.id}"
  count                     = "${var.condition["data_brewprod"] == 1 ? var.az_count : 0}"
}

resource "aws_route" "data_prod_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.data["comp_prod_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_prod.id}"
  count                     = "${var.condition["data_prod"] == 1 ? var.az_count : 0}"
}

# Peer routes between MS and Reco account VPCs

resource "aws_route" "reco_integ_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.reco["comp_integ_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.reco_integ.id}"
  count                     = "${var.condition["reco_integ"] == 1 ? var.az_count : 0}"
}

resource "aws_route" "reco_test_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.reco["comp_test_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.reco_test.id}"
  count                     = "${var.condition["reco_test"] == 1 ? var.az_count : 0}"
}

resource "aws_route" "reco_release_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.reco["comp_release_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.reco_release.id}"
  count                     = "${var.condition["reco_release"] == 1 ? var.az_count : 0}"
}

resource "aws_route" "reco_brewprod_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.reco["comp_brewprod_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.reco_brewprod.id}"
  count                     = "${var.condition["reco_brewprod"] == 1 ? var.az_count : 0}"
}

resource "aws_route" "reco_prod_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.reco["comp_prod_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.reco_prod.id}"
  count                     = "${var.condition["reco_prod"] == 1 ? var.az_count : 0}"
}

# Peer route from Microservices VPC to JCX VPC - Same account

resource "aws_route" "jcx_comp_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.jcx["ms_acc_jcx_vpc_cidr"]}"
  vpc_peering_connection_id = "${var.jcx["ms_acc_jcx_peer_id"]}"
  count                     = "${var.condition["ms_vpc"] == 1 ? var.az_count : 0}"
}

# Peer route from JCX VPC to Microservices VPC - Same account

resource "aws_route" "microservices_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.jcx["ms_acc_ms_vpc_cidr"]}"
  vpc_peering_connection_id = "${var.jcx["ms_acc_ms_peer_id"]}"
  count                     = "${var.condition["jcx_vpc"] == 1 ? var.az_count : 0}"
}

# Peer route from Microservices Prod VPC to Microservices Pipeline VPC

resource "aws_route" "ms_prod_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.ms["comp_pipeline_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.ms_pipeline.id}"
  count                     = "${var.condition["ms_prod"] == 1 ? var.az_count : 0}"
}

# Peer route from Microservices Pipeline VPC to Microservices Prod VPC

resource "aws_route" "ms_pipeline_vpc_natdc" {
  route_table_id            = "${element(aws_route_table.natdc.*.id, count.index)}"
  destination_cidr_block    = "${var.ms["comp_prod_vpc_cidr"]}"
  vpc_peering_connection_id = "${var.ms["prod_peer_id"]}"
  count                     = "${var.condition["ms_pipeline"] == 1 ? var.az_count : 0}"
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

# Peer routes between MS-JCX and Data account VPCs

resource "aws_route" "data_jcx_integ_vpc_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.data["comp_integ_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_jcx_integ.id}"
  count                     = "${var.condition["data_jcx_integ"]}"
}

resource "aws_route" "data_jcx_test_vpc_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.data["comp_test_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_jcx_test.id}"
  count                     = "${var.condition["data_jcx_test"]}"
}

resource "aws_route" "data_jcx_release_vpc_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.data["comp_release_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_jcx_release.id}"
  count                     = "${var.condition["data_jcx_release"]}"
}

resource "aws_route" "data_jcx_prod_vpc_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.data["comp_prod_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_jcx_prod.id}"
  count                     = "${var.condition["data_jcx_prod"]}"
}

# Peer routes between MS and Data account VPCs

resource "aws_route" "data_integ_vpc_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.data["comp_integ_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_integ.id}"
  count                     = "${var.condition["data_integ"]}"
}

resource "aws_route" "data_test_vpc_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.data["comp_test_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_test.id}"
  count                     = "${var.condition["data_test"]}"
}

resource "aws_route" "data_release_vpc_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.data["comp_release_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_release.id}"
  count                     = "${var.condition["data_release"]}"
}

resource "aws_route" "data_brewprod_vpc_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.data["comp_brewprod_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_brewprod.id}"
  count                     = "${var.condition["data_brewprod"]}"
}

resource "aws_route" "data_prod_vpc_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.data["comp_prod_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_prod.id}"
  count                     = "${var.condition["data_prod"]}"
}

# Peer routes between MS and Reco account VPCs

resource "aws_route" "reco_integ_vpc_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.reco["comp_integ_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.reco_integ.id}"
  count                     = "${var.condition["reco_integ"]}"
}

resource "aws_route" "reco_test_vpc_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.reco["comp_test_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.reco_test.id}"
  count                     = "${var.condition["reco_test"]}"
}

resource "aws_route" "reco_release_vpc_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.reco["comp_release_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.reco_release.id}"
  count                     = "${var.condition["reco_release"]}"
}

resource "aws_route" "reco_brewprod_vpc_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.reco["comp_brewprod_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.reco_brewprod.id}"
  count                     = "${var.condition["reco_brewprod"]}"
}

resource "aws_route" "reco_prod_vpc_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.reco["comp_prod_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.reco_prod.id}"
  count                     = "${var.condition["reco_prod"]}"
}

# Peer route from Microservices VPC to JCX VPC - Same account

resource "aws_route" "jcx_comp_vpc_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.jcx["ms_acc_jcx_vpc_cidr"]}"
  vpc_peering_connection_id = "${var.jcx["ms_acc_jcx_peer_id"]}"
  count                     = "${var.condition["ms_vpc"]}"
}

# Peer route from JCX VPC to Microservices VPC - Same account

resource "aws_route" "microservices_vpc_public" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "${var.jcx["ms_acc_ms_vpc_cidr"]}"
  vpc_peering_connection_id = "${var.jcx["ms_acc_ms_peer_id"]}"
  count                     = "${var.condition["jcx_vpc"]}"
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

# Peer routes between MS-JCX and Data account VPCs

resource "aws_route" "data_jcx_integ_vpc_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.data["comp_integ_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_jcx_integ.id}"
  count                     = "${var.condition["data_jcx_integ"]}"
}

resource "aws_route" "data_jcx_test_vpc_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.data["comp_test_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_jcx_test.id}"
  count                     = "${var.condition["data_jcx_test"]}"
}

resource "aws_route" "data_jcx_release_vpc_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.data["comp_release_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_jcx_release.id}"
  count                     = "${var.condition["data_jcx_release"]}"
}

resource "aws_route" "data_jcx_prod_vpc_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.data["comp_prod_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_jcx_prod.id}"
  count                     = "${var.condition["data_jcx_prod"]}"
}

# Peer routes between MS and Data account VPCs

resource "aws_route" "data_integ_vpc_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.data["comp_integ_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_integ.id}"
  count                     = "${var.condition["data_integ"]}"
}

resource "aws_route" "data_test_vpc_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.data["comp_test_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_test.id}"
  count                     = "${var.condition["data_test"]}"
}

resource "aws_route" "data_release_vpc_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.data["comp_release_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_release.id}"
  count                     = "${var.condition["data_release"]}"
}

resource "aws_route" "data_brewprod_vpc_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.data["comp_brewprod_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_brewprod.id}"
  count                     = "${var.condition["data_brewprod"]}"
}

resource "aws_route" "data_prod_vpc_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.data["comp_prod_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.data_prod.id}"
  count                     = "${var.condition["data_prod"]}"
}

# Peer routes between MS and Reco account VPCs

resource "aws_route" "reco_integ_vpc_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.reco["comp_integ_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.reco_integ.id}"
  count                     = "${var.condition["reco_integ"]}"
}

resource "aws_route" "reco_test_vpc_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.reco["comp_test_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.reco_test.id}"
  count                     = "${var.condition["reco_test"]}"
}

resource "aws_route" "reco_release_vpc_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.reco["comp_release_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.reco_release.id}"
  count                     = "${var.condition["reco_release"]}"
}

resource "aws_route" "reco_brewprod_vpc_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.reco["comp_brewprod_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.reco_brewprod.id}"
  count                     = "${var.condition["reco_brewprod"]}"
}

resource "aws_route" "reco_prod_vpc_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.reco["comp_prod_vpc_cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.reco_prod.id}"
  count                     = "${var.condition["reco_prod"]}"
}

# Peer route from Microservices VPC to JCX VPC - Same account

resource "aws_route" "jcx_comp_vpc_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.jcx["ms_acc_jcx_vpc_cidr"]}"
  vpc_peering_connection_id = "${var.jcx["ms_acc_jcx_peer_id"]}"
  count                     = "${var.condition["ms_vpc"]}"
}

# Peer route from JCX VPC to Microservices VPC - Same account

resource "aws_route" "microservices_vpc_private" {
  route_table_id            = "${aws_route_table.private.id}"
  destination_cidr_block    = "${var.jcx["ms_acc_ms_vpc_cidr"]}"
  vpc_peering_connection_id = "${var.jcx["ms_acc_ms_peer_id"]}"
  count                     = "${var.condition["jcx_vpc"]}"
}

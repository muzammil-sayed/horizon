# Peering connections between VPCs

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

### VPC Peering Data component VPCs with Reco account component VPCs ###

resource "aws_vpc_peering_connection" "data_reco_integ" {
  peer_owner_id = "${var.reco["aws_account_id"]}"
  peer_vpc_id   = "${var.reco["comp_integ_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["build_data_reco_integ"]}"

  tags {
    Name           = "${var.env}_to_reco_account_integ"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_vpc_peering_connection" "data_reco_test" {
  peer_owner_id = "${var.reco["aws_account_id"]}"
  peer_vpc_id   = "${var.reco["comp_test_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["build_data_reco_test"]}"

  tags {
    Name           = "${var.env}_to_reco_account_test"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_vpc_peering_connection" "data_reco_release" {
  peer_owner_id = "${var.reco["aws_account_id"]}"
  peer_vpc_id   = "${var.reco["comp_release_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["build_data_reco_release"]}"

  tags {
    Name           = "${var.env}_to_reco_account_release"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_vpc_peering_connection" "data_reco_brewprod" {
  peer_owner_id = "${var.reco["aws_account_id"]}"
  peer_vpc_id   = "${var.reco["comp_brewprod_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["build_data_reco_brewprod"]}"

  tags {
    Name           = "${var.env}_to_reco_account_brewprod"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_vpc_peering_connection" "data_reco_prod" {
  peer_owner_id = "${var.reco["aws_account_id"]}"
  peer_vpc_id   = "${var.reco["comp_prod_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["build_data_reco_prod"]}"

  tags {
    Name           = "${var.env}_to_reco_account_prod"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

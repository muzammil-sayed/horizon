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

### VPC Peering MS VPC(s) with Bikou main VPC ###
resource "aws_vpc_peering_connection" "bikou" {
  peer_owner_id = "${var.bikou["aws_account_id"]}"
  peer_vpc_id   = "${var.bikou["main_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["bikou"]}"

  tags {
    Name           = "${var.env}_to_bikou"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

### VPC Peering MS-JCX component VPC with Data account component VPCs ###

resource "aws_vpc_peering_connection" "data_jcx_integ" {
  peer_owner_id = "${var.data["aws_account_id"]}"
  peer_vpc_id   = "${var.data["comp_integ_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["data_jcx_integ"]}"

  tags {
    Name           = "${var.env}_to_data_account_integ"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_vpc_peering_connection" "data_jcx_test" {
  peer_owner_id = "${var.data["aws_account_id"]}"
  peer_vpc_id   = "${var.data["comp_test_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["data_jcx_test"]}"

  tags {
    Name           = "${var.env}_to_data_account_test"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_vpc_peering_connection" "data_jcx_release" {
  peer_owner_id = "${var.data["aws_account_id"]}"
  peer_vpc_id   = "${var.data["comp_release_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["data_jcx_release"]}"

  tags {
    Name           = "${var.env}_to_data_account_release"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_vpc_peering_connection" "data_jcx_prod" {
  peer_owner_id = "${var.data["aws_account_id"]}"
  peer_vpc_id   = "${var.data["comp_prod_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["data_jcx_prod"]}"

  tags {
    Name           = "${var.env}_to_data_account_prod"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

### VPC Peering MS component VPCs with Data account component VPCs ###

resource "aws_vpc_peering_connection" "data_integ" {
  peer_owner_id = "${var.data["aws_account_id"]}"
  peer_vpc_id   = "${var.data["comp_integ_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["data_integ"]}"

  tags {
    Name           = "${var.env}_to_data_account_integ"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_vpc_peering_connection" "data_test" {
  peer_owner_id = "${var.data["aws_account_id"]}"
  peer_vpc_id   = "${var.data["comp_test_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["data_test"]}"

  tags {
    Name           = "${var.env}_to_data_account_test"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_vpc_peering_connection" "data_release" {
  peer_owner_id = "${var.data["aws_account_id"]}"
  peer_vpc_id   = "${var.data["comp_release_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["data_release"]}"

  tags {
    Name           = "${var.env}_to_data_account_release"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_vpc_peering_connection" "data_brewprod" {
  peer_owner_id = "${var.data["brewprod_aws_account_id"]}"
  peer_vpc_id   = "${var.data["comp_brewprod_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["data_brewprod"]}"

  tags {
    Name           = "${var.env}_to_data_account_brewprod"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_vpc_peering_connection" "data_prod" {
  peer_owner_id = "${var.data["aws_account_id"]}"
  peer_vpc_id   = "${var.data["comp_prod_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["data_prod"]}"

  tags {
    Name           = "${var.env}_to_data_account_prod"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

### VPC Peering MS component VPCs with Reco account component VPCs ###

resource "aws_vpc_peering_connection" "reco_integ" {
  peer_owner_id = "${var.reco["aws_account_id"]}"
  peer_vpc_id   = "${var.reco["comp_integ_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["reco_integ"]}"

  tags {
    Name           = "${var.env}_to_reco_account_integ"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_vpc_peering_connection" "reco_test" {
  peer_owner_id = "${var.reco["aws_account_id"]}"
  peer_vpc_id   = "${var.reco["comp_test_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["reco_test"]}"

  tags {
    Name           = "${var.env}_to_reco_account_test"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_vpc_peering_connection" "reco_release" {
  peer_owner_id = "${var.reco["aws_account_id"]}"
  peer_vpc_id   = "${var.reco["comp_release_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["reco_release"]}"

  tags {
    Name           = "${var.env}_to_reco_account_release"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_vpc_peering_connection" "reco_brewprod" {
  peer_owner_id = "${var.reco["brewprod_aws_account_id"]}"
  peer_vpc_id   = "${var.reco["comp_brewprod_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["reco_brewprod"]}"

  tags {
    Name           = "${var.env}_to_reco_account_brewprod"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_vpc_peering_connection" "reco_prod" {
  peer_owner_id = "${var.reco["aws_account_id"]}"
  peer_vpc_id   = "${var.reco["comp_prod_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["reco_prod"]}"

  tags {
    Name           = "${var.env}_to_reco_account_prod"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

### VPC Peering with JCX component VPC ###

resource "aws_vpc_peering_connection" "jcx" {
  peer_owner_id = "${var.aws_account_id}"
  peer_vpc_id   = "${var.jcx["comp_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  auto_accept   = true
  count         = "${var.condition["ms_vpc"]}"

  tags {
    Name           = "${var.env}_to_jcx_component_vpc"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

### VPC Peering between MS-Prod and MS-Pipeline VPCs ###

resource "aws_vpc_peering_connection" "ms_pipeline" {
  peer_owner_id = "${var.ms["pipeline_aws_account_id"]}"
  peer_vpc_id   = "${var.ms["comp_pipeline_vpc_id"]}"
  vpc_id        = "${aws_vpc.main.id}"
  count         = "${var.condition["ms_prod"]}"

  tags {
    Name           = "${var.env}_to_ms_pipeline"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}
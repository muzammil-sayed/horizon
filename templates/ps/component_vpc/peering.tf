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

/*
VPN Connection to Jive DC

NOTE: the aws_customer_gateway is defined in infra_vpc, shared here via
horizon.yaml, and referenced as var.aws_customer_gateway_corp_customer_gateway
*/
resource "aws_vpn_connection" "corp_main" {
  vpn_gateway_id      = "${aws_vpn_gateway.vgw.id}"
  customer_gateway_id = "${var.aws_customer_gateway_corp_customer_gateway}"
  type                = "ipsec.1"
  static_routes_only  = "${var.jive_corp_vpn_static_routes_only}"
  count               = "${var.condition_corp_vpn["build_corp_vpn"]}"

  tags {
    Name           = "${var.env}-jive-vpn"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_vpn_connection_route" "route_10_5" {
  destination_cidr_block = "10.5.0.0/16"
  vpn_connection_id      = "${aws_vpn_connection.corp_main.id}"
  count                  = "${var.condition_corp_vpn["build_corp_vpn"]}"
}

resource "aws_vpn_connection_route" "route_10_6" {
  destination_cidr_block = "10.6.0.0/16"
  vpn_connection_id      = "${aws_vpn_connection.corp_main.id}"
  count                  = "${var.condition_corp_vpn["build_corp_vpn"]}"
}

resource "aws_vpn_connection_route" "route_10_7" {
  destination_cidr_block = "10.7.0.0/16"
  vpn_connection_id      = "${aws_vpn_connection.corp_main.id}"
  count                  = "${var.condition_corp_vpn["build_corp_vpn"]}"
}

resource "aws_vpn_connection_route" "route_10_46" {
  destination_cidr_block = "10.46.0.0/16"
  vpn_connection_id      = "${aws_vpn_connection.corp_main.id}"
  count                  = "${var.condition_corp_vpn["build_corp_vpn"]}"
}

resource "aws_vpn_connection_route" "route_10_61" {
  destination_cidr_block = "10.61.0.0/16"
  vpn_connection_id      = "${aws_vpn_connection.corp_main.id}"
  count                  = "${var.condition_corp_vpn["build_corp_vpn"]}"
}

resource "aws_vpn_connection_route" "route_10_81" {
  destination_cidr_block = "10.81.0.0/16"
  vpn_connection_id      = "${aws_vpn_connection.corp_main.id}"
  count                  = "${var.condition_corp_vpn["build_corp_vpn"]}"
}

resource "aws_vpn_connection_route" "route_10_82" {
  destination_cidr_block = "10.82.0.0/16"
  vpn_connection_id      = "${aws_vpn_connection.corp_main.id}"
  count                  = "${var.condition_corp_vpn["build_corp_vpn"]}"
}

resource "aws_vpn_connection_route" "route_10_84" {
  destination_cidr_block = "10.84.0.0/16"
  vpn_connection_id      = "${aws_vpn_connection.corp_main.id}"
  count                  = "${var.condition_corp_vpn["build_corp_vpn"]}"
}

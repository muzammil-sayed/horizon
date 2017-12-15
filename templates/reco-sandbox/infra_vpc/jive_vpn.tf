#VPN Connection to Jive DC
resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = 13364
  ip_address = "${var.jive_vpn_ip}"
  type       = "ipsec.1"
  count      = "${var.condition_vpn["build_vpn"]}"

  tags {
    Name           = "${var.env}-customer-gateway"
    Pipeline_phase = "${var.env}"
    Region         = "${var.region}"
    SLA            = "${var.sla}"
    Account_name   = "${var.aws_account_short_name}"
  }
}

resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = "${aws_vpn_gateway.vgw.id}"
  customer_gateway_id = "${aws_customer_gateway.customer_gateway.id}"
  type                = "ipsec.1"
  static_routes_only  = false
  count               = "${var.condition_vpn["build_vpn"]}"

  tags {
    Name           = "${var.env}-jive-vpn"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}


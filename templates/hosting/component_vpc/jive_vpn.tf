#VPN Connection to Jive DC
resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = "${aws_vpn_gateway.vgw.id}"
  customer_gateway_id = "${var.vpn_customer_gateway}"
  type                = "ipsec.1"
  static_routes_only  = false
  count               = "${var.condition["build_vpn"]}"

  tags {
    Name           = "${var.env}-jive-vpn"
    pipeline_phase = "${var.env}"
    region         = "${var.region}"
    sla            = "${var.sla}"
    account_name   = "${var.aws_account_short_name}"
  }
}

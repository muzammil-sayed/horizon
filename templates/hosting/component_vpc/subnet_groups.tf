resource "aws_db_subnet_group" "dbaas" {
  name        = "data-dbaas-${lookup(var.mako_env, var.env)}-group"
  subnet_ids  = ["${aws_subnet.natdc.*.id}"]
  #subnet_ids  = ["${element(aws_subnet.natdc.*.id, count.index)}"]
  description = "Managed by Horizon"
  count       = "${var.condition["ms_dbaas"]}"
  #count       = "${var.condition["ms_dbaas"] == 1 ? var.az_count : 0}"

  tags {
    Name              = "data-dbaas2-${lookup(var.mako_env, var.env)}-group"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
    service_component = "${var.jive_service}-dbaas"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
  }
}

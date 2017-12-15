resource "aws_s3_bucket" "jive-datadog-monitors-s3" {
  bucket        = "jive-datadog-${var.aws_account_short_name}-usw2"
  force_destroy = true

  tags {
    pipeline_phase = "${var.env}"
    jive_service = "infrastructure"
    service_component = "datadog"
  }
}

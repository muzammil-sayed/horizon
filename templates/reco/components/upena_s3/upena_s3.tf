resource "aws_s3_bucket" "upena_bucket" {
  bucket = "${var.region}-${var.aws_account_short_name}-${var.upena_s3_bucket}"
  acl = "private"
}

resource "aws_s3_bucket_object" "upena_bootstrap" {
  bucket = "${aws_s3_bucket.upena_bucket.bucket}"
  key = "bin/bootstrap.sh"
  source = "bootstrap.sh"
  etag = "${md5(file("bootstrap.sh"))}"
}

resource "aws_s3_bucket_object" "upena_sync" {
  bucket = "${aws_s3_bucket.upena_bucket.bucket}"
  key = "bin/sync.sh"
  source = "sync.sh"
  etag = "${md5(file("sync.sh"))}"
}

resource "aws_s3_bucket_object" "upena_init" {
  bucket = "${aws_s3_bucket.upena_bucket.bucket}"
  key = "bin/init.sh"
  source = "init.sh"
  etag = "${md5(file("init.sh"))}"
}

resource "aws_s3_bucket_object" "upena_upena" {
  bucket = "${aws_s3_bucket.upena_bucket.bucket}"
  key = "bin/upena.sh"
  source = "upena.sh"
  etag = "${md5(file("upena.sh"))}"
}

resource "aws_s3_bucket_object" "upena_datadog" {
  bucket = "${aws_s3_bucket.upena_bucket.bucket}"
  key = "bin/datadog.sh"
  source = "datadog.sh"
  etag = "${md5(file("datadog.sh"))}"
}

resource "aws_s3_bucket_object" "upena_keepalive" {
  bucket = "${aws_s3_bucket.upena_bucket.bucket}"
  key = "bin/keepalive.sh"
  source = "keepalive.sh"
  etag = "${md5(file("keepalive.sh"))}"
}

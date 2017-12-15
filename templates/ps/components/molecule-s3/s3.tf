resource "aws_s3_bucket" "molecule" {
  bucket = "${replace(var.aws_account_short_name, "/jive-ps-(.*)/", "boomi-$1-molecule")}"
  acl    = "private"

  tags {
    account_name = "${var.aws_account_short_name}"
    jive_service = "boomi"
  }
}

resource "aws_s3_bucket_object" "molecule_node_setup" {
  bucket = "${aws_s3_bucket.molecule.id}"
  key    = "bin/setup.sh"
  source = "bucket/bin/setup.sh"
  etag   = "${md5(file("bucket/bin/setup.sh"))}"
}

resource "aws_s3_bucket_object" "molecule_snapshot" {
  bucket = "${aws_s3_bucket.molecule.id}"
  key    = "bin/molecule-snapshot.sh"
  source = "bucket/bin/molecule-snapshot.sh"
  etag   = "${md5(file("bucket/bin/molecule-snapshot.sh"))}"
}

resource "aws_s3_bucket_object" "molecule_volume_swap" {
  bucket = "${aws_s3_bucket.molecule.id}"
  key    = "bin/molecule-volume-swap.sh"
  source = "bucket/bin/molecule-volume-swap.sh"
  etag   = "${md5(file("bucket/bin/molecule-volume-swap.sh"))}"
}

resource "aws_s3_bucket_object" "molecule_service" {
  bucket = "${aws_s3_bucket.molecule.id}"
  key    = "atom.service"
  source = "bucket/atom.service"
  etag   = "${md5(file("bucket/atom.service"))}"
}

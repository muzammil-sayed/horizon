resource "template_file" "s3_policy" {
  template = <<TEMPLATE
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AddPerm",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${bucket}/*"
        }
    ]
}
TEMPLATE

  vars {
    bucket = "jcx-releases-${var.region}"
  }
}

resource "aws_s3_bucket" "jcx-releases" {
  bucket = "jcx-releases-${var.region}"
  acl    = "private"

  versioning {
    enabled = true
  }

  policy = "${template_file.s3_policy.rendered}"

  tags {
    jive_service = "jcx"
    pipeline_phase = "${var.env}"
  }
}

resource "aws_cloudtrail" "cloudtrail-configuration" {
  name                       = "${var.aws_account_short_name}-cloudtrail"
  is_multi_region_trail      = true
  s3_bucket_name             = "${aws_s3_bucket.cloudtrail.id}"
  cloud_watch_logs_role_arn  = "${aws_iam_role.cloudtrail_cloudwatch.arn}"
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}"

  tags {
    jive_service      = "infrastructure"
    service_component = "cloudtrail"
  }
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "jive-cloudtrail-${var.aws_account_short_name}-usw2"
  force_destroy = true

  tags {
    pipeline_phase    = "${var.env}"
    jive_service      = "infrastructure"
    service_component = "cloudtrail"
  }

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailAclCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::jive-cloudtrail-${var.aws_account_short_name}-usw2"
    },
    {
      "Sid": "AWSCloudTrailWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::jive-cloudtrail-${var.aws_account_short_name}-usw2/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Sid": "DenyUnEncryptedObjectUploads",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::jive-cloudtrail-${var.aws_account_short_name}-usw2/*",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "AES256"
        }
      }
    }
  ]
}
POLICY
}

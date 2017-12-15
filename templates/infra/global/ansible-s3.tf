resource "aws_s3_bucket" "ansible" {
  bucket = "jive-ansible-${var.aws_account_short_name}-usw2"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    prefix  = "ansible/"
    enabled = true

    noncurrent_version_transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      days = 180
    }
  }

  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AllowAnsibleDownload",
      "Effect":"Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::999547976641:root",
          "arn:aws:iam::409573287771:root",
          "arn:aws:iam::467524913882:root",
          "arn:aws:iam::811034720611:root",
          "arn:aws:iam::193204500816:root",
          "arn:aws:iam::663559125979:root",
          "arn:aws:iam::549229563172:root",
          "arn:aws:iam::642745549043:root",
          "arn:aws:iam::870846026232:root",
          "arn:aws:iam::044571148504:root",
          "arn:aws:iam::874979382819:root",
          "arn:aws:iam::517449413234:root",
          "arn:aws:iam::816602928515:root",
          "arn:aws:iam::403612517204:root",
          "arn:aws:iam::236799202671:root",
          "arn:aws:iam::704799964251:root",
          "arn:aws:iam::819473657664:root",
          "arn:aws:iam::041205748055:root",
          "arn:aws:iam::293490559745:root",
          "arn:aws:iam::922236644688:root"
        ]
      },
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::jive-ansible-${var.aws_account_short_name}-usw2/*"]
    },
    {
      "Sid":"AllowAnsibleUpload",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:PutObject"],
      "Resource":["arn:aws:s3:::jive-ansible-${var.aws_account_short_name}-usw2/*"],
      "Condition": {
         "IpAddress": {
           "aws:SourceIp": "${var.jive_phx_ip}"
         }
      }
    }
  ]
}
EOF

  tags {
    Name              = "jive-ansible-${var.aws_account_short_name}-usw2"
    pipeline_phase    = "${var.env}"
    service_component = "ansible"
    jive_service      = "infrastructure"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
  }
}

resource "aws_s3_bucket" "ansible_coreos" {
  bucket = "jive-ansible-coreos-${var.aws_account_short_name}-usw2"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    prefix  = "ansible-coreos/"
    enabled = true

    noncurrent_version_transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      days = 180
    }
  }

  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AllowAnsibleDownload",
      "Effect":"Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::999547976641:root",
          "arn:aws:iam::409573287771:root",
          "arn:aws:iam::467524913882:root",
          "arn:aws:iam::811034720611:root",
          "arn:aws:iam::193204500816:root",
          "arn:aws:iam::663559125979:root",
          "arn:aws:iam::549229563172:root",
          "arn:aws:iam::642745549043:root",
          "arn:aws:iam::870846026232:root",
          "arn:aws:iam::044571148504:root",
          "arn:aws:iam::874979382819:root",
          "arn:aws:iam::517449413234:root",
          "arn:aws:iam::816602928515:root",
          "arn:aws:iam::403612517204:root",
          "arn:aws:iam::236799202671:root",
          "arn:aws:iam::704799964251:root",
          "arn:aws:iam::819473657664:root",
          "arn:aws:iam::041205748055:root",
          "arn:aws:iam::922236644688:root"
        ]
      },
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::jive-ansible-coreos-${var.aws_account_short_name}-usw2/*"]
    },
    {
      "Sid":"AllowAnsibleUpload",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:PutObject"],
      "Resource":["arn:aws:s3:::jive-ansible-coreos-${var.aws_account_short_name}-usw2/*"],
      "Condition": {
         "IpAddress": {
           "aws:SourceIp": "${var.jive_phx_ip}"
         }
      }
    }
  ]
}
EOF

  tags {
    Name              = "jive-ansible-coreos-${var.aws_account_short_name}-usw2"
    pipeline_phase    = "${var.env}"
    service_component = "ansible"
    jive_service      = "infrastructure"
    region            = "${var.region}"
    sla               = "${var.sla}"
    account_name      = "${var.aws_account_short_name}"
  }
}

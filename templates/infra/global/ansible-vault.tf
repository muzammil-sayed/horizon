resource "aws_s3_bucket" "ansible_vault" {
  bucket        = "jive-ansible-vault-${var.aws_account_short_name}-usw2"
  force_destroy = true

  tags {
    pipeline_phase = "${var.env}"
    jive_service = "infrastructure"
    service_component = "ansible"
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "statement2",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                  "arn:aws:iam::368751757243:root",
                  "arn:aws:iam::356028461833:root",
                  "arn:aws:iam::378291628856:root",
                  "arn:aws:iam::999547976641:root",
                  "arn:aws:iam::409573287771:root",
                  "arn:aws:iam::467524913882:root",
                  "arn:aws:iam::811034720611:root",
                  "arn:aws:iam::193204500816:root",
                  "arn:aws:iam::663559125979:root",
                  "arn:aws:iam::870846026232:root",
                  "arn:aws:iam::549229563172:root",
                  "arn:aws:iam::642745549043:root",
                  "arn:aws:iam::803801599679:root",
                  "arn:aws:iam::046080910130:root",
                  "arn:aws:iam::044571148504:root",
                  "arn:aws:iam::874979382819:root",
                  "arn:aws:iam::517449413234:root",
                  "arn:aws:iam::816602928515:root",
                  "arn:aws:iam::403612517204:root",
                  "arn:aws:iam::922236644688:root",
                  "arn:aws:iam::293490559745:root"
                ]
            },
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::jive-ansible-vault-${var.aws_account_short_name}-usw2",
                "arn:aws:s3:::jive-ansible-vault-${var.aws_account_short_name}-usw2/*"
            ]
        }
    ]
}
  POLICY
}


resource "aws_s3_bucket" "ansible_coreos_vault" {
  bucket        = "jive-ansible-coreos-vault-${var.aws_account_short_name}-usw2"
  force_destroy = true

  tags {
    pipeline_phase = "${var.env}"
    jive_service = "infrastructure"
    service_component = "ansible"
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "statement1",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::jive-ansible-coreos-vault-${var.aws_account_short_name}-usw2",
                "arn:aws:s3:::jive-ansible-coreos-vault-${var.aws_account_short_name}-usw2/*"
            ],
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": [
                         "10.96.0.0/12",
                         "10.128.0.0/12",
                         "10.160.0.0/12",
                         "10.176.0.0/12",
                         "10.190.0.0/12",
                         "10.248.0.0/12",
                         "204.93.64.4/32",
                         "204.93.80.112/32",
                         "204.93.80.113/32",
                         "204.93.80.118/32",
                         "204.93.80.119/32",
                         "204.93.95.112/32",
                         "204.93.95.113/32",
                         "204.93.95.114/32",
                         "204.93.95.115/32",
                         "192.250.208.115/32",
                         "192.250.208.116/32",
                         "192.250.208.117/32",
                         "192.250.208.118/32"
                    ]
                }
            }
        },
        {
            "Sid": "statement2",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                  "arn:aws:iam::368751757243:root",
                  "arn:aws:iam::356028461833:root",
                  "arn:aws:iam::378291628856:root",
                  "arn:aws:iam::999547976641:root",
                  "arn:aws:iam::409573287771:root",
                  "arn:aws:iam::467524913882:root",
                  "arn:aws:iam::811034720611:root",
                  "arn:aws:iam::193204500816:root",
                  "arn:aws:iam::663559125979:root",
                  "arn:aws:iam::870846026232:root",
                  "arn:aws:iam::549229563172:root",
                  "arn:aws:iam::642745549043:root",
                  "arn:aws:iam::803801599679:root",
                  "arn:aws:iam::046080910130:root",
                  "arn:aws:iam::044571148504:root",
                  "arn:aws:iam::874979382819:root",
                  "arn:aws:iam::517449413234:root",
                  "arn:aws:iam::816602928515:root",
                  "arn:aws:iam::403612517204:root",
                  "arn:aws:iam::922236644688:root"
                ]
            },
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::jive-ansible-coreos-vault-${var.aws_account_short_name}-usw2",
                "arn:aws:s3:::jive-ansible-coreos-vault-${var.aws_account_short_name}-usw2/*"
            ]

        }
    ]
}
  POLICY
}


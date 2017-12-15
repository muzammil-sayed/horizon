resource "aws_s3_bucket" "ansible_coreos_vault" {
  bucket        = "jive-ansible-coreos-vault-${var.aws_account_short_name}"
  force_destroy = true

  tags {
    pipeline_phase    = "${var.env}"
    jive_service      = "infrastructure"
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
                "arn:aws:s3:::jive-ansible-coreos-vault-${var.aws_account_short_name}",
                "arn:aws:s3:::jive-ansible-coreos-vault-${var.aws_account_short_name}/*"
            ],
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": [
                         "10.0.0.0/8"
                    ]
                }
            }
        },
        {
            "Sid": "statement2",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                  "arn:aws:iam::${var.aws_account_id}:root"
                ]
            },
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::jive-ansible-coreos-vault-${var.aws_account_short_name}",
                "arn:aws:s3:::jive-ansible-coreos-vault-${var.aws_account_short_name}/*"
            ]

        }
    ]
}
  POLICY
}

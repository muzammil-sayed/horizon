{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "statement201609211128",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${aws_account}:role/${region}-ebs-attach-and-secrets-role-${jive_subservice}"
      },
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:ListBucketMultipartUploads",
        "s3:ListBucketVersions"
      ],
      "Resource": "arn:aws:s3:::${region}-jive-data-${pipeline_phase}-${jive_subservice}-snaps"
    },
    {
      "Sid": "statement201609211130",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${aws_account}:role/${region}-ebs-attach-and-secrets-role-${jive_subservice}"
      },
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:AbortMultipartUpload",
        "s3:ListMultipartUploadParts"
      ],
      "Resource": "arn:aws:s3:::${region}-jive-data-${pipeline_phase}-${jive_subservice}-snaps/*"
    }
  ]
}

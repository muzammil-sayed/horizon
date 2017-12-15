data "aws_iam_policy_document" "s3_lemu_policy_document" {
  statement {
    sid    = "Allow lemur"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      "arn:aws:s3:::${var.region}-${var.aws_account_short_name}${var.kube_extra_id}-#ROLE/*",
    ]

    principals = {
      type        = "AWS"
      identifiers = ["arn:aws:iam::417900408555:role/Lemur"]
    }
  }
}

resource "aws_s3_bucket" "tardis_svc" {
  bucket = "${var.region}-${var.aws_account_short_name}${var.kube_extra_id}-tardis-svc"
  acl    = "private"

  versioning {
    enabled = true
  }

  policy = "${replace(data.aws_iam_policy_document.s3_lemu_policy_document.json, "#ROLE", "tardis-svc")}"

  tags {
    Name              = "${var.region}-${var.aws_account_short_name}${var.kube_extra_id}-tardis-svc"
    pipeline_phase    = "${var.env}"
    Service_component = "tardis"
    region            = "${var.region}"
    KubernetesCluster = "${var.region}_${var.aws_account_short_name}${var.kube_extra_id}"
  }
}

data "aws_iam_policy_document" "s3_policy_build" {
  statement {
    sid    = "AddPerm"
    effect = "Allow"

    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::tardis-build-${var.region}-${var.aws_account_short_name}${var.kube_extra_id}/*",
    ]

    principals = {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket" "tardis-build" {
  bucket = "tardis-build-${var.region}-${var.aws_account_short_name}${var.kube_extra_id}"
  acl    = "private"

  versioning {
    enabled = true
  }

  policy = "${data.aws_iam_policy_document.s3_policy_build.json}"

  tags {
    jive_service      = "tardis"
    Name              = "tardis-build-${var.region}-${var.aws_account_short_name}${var.kube_extra_id}"
    pipeline_phase    = "${var.env}"
    Service_component = "tardis_build"
    region            = "${var.region}"
    KubernetesCluster = "${var.region}_${var.aws_account_short_name}${var.kube_extra_id}"
  }
}

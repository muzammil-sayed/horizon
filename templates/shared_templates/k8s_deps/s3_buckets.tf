/* This is a separate component that needs to be created before Lemur certs
are generated for the cluster. */

data "aws_iam_policy_document" "s3_lemur_policy_document" {
  statement {
    sid = "Allow lemur",
    effect = "Allow",
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ],
    resources = [
      "arn:aws:s3:::${var.region}-${var.aws_account_short_name}${var.kube_extra_id}-#ROLE/*"
    ],
    principals = {
      type = "AWS",
      identifiers = ["arn:aws:iam::417900408555:role/Lemur"]
    }
  }
}

resource "aws_s3_bucket" "master" {
  bucket = "${var.region}-${var.aws_account_short_name}${var.kube_extra_id}-master"
  acl    = "private"

  versioning {
    enabled = true
  }

  policy = "${replace(data.aws_iam_policy_document.s3_lemur_policy_document.json, "#ROLE", "master")}"

  tags {
    KubernetesCluster = "${var.region}_${var.aws_account_short_name}${var.kube_extra_id}"
    Service_component = "k8s-master"
  }
}

resource "aws_s3_bucket" "node" {
  bucket = "${var.region}-${var.aws_account_short_name}${var.kube_extra_id}-node"
  acl    = "private"

  versioning {
    enabled = true
  }

  policy = "${replace(data.aws_iam_policy_document.s3_lemur_policy_document.json, "#ROLE", "node")}"

  tags {
    KubernetesCluster = "${var.region}_${var.aws_account_short_name}${var.kube_extra_id}"
    Service_component = "k8s-worker"
  }
}

resource "aws_s3_bucket" "etcd" {
  bucket = "${var.region}-${var.aws_account_short_name}${var.kube_extra_id}-etcd"
  acl    = "private"

  versioning {
    enabled = true
  }

  policy = "${replace(data.aws_iam_policy_document.s3_lemur_policy_document.json, "#ROLE", "etcd")}"

  tags {
    KubernetesCluster = "${var.region}_${var.aws_account_short_name}${var.kube_extra_id}"
    Service_component = "k8s-etcd"
  }
}

resource "aws_s3_bucket" "admin" {
  bucket = "${var.region}-${var.aws_account_short_name}${var.kube_extra_id}-admin"
  acl    = "private"

  versioning {
    enabled = true
  }

  policy = "${replace(data.aws_iam_policy_document.s3_lemur_policy_document.json, "#ROLE", "admin")}"

  tags {
    KubernetesCluster = "${var.region}_${var.aws_account_short_name}${var.kube_extra_id}"
    Service_component = "k8s-admin"
  }
}

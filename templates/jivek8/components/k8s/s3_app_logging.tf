data "aws_iam_policy_document" "logging" {
  statement {
    sid = "Logs",
    effect = "Allow",
    actions = [
      "s3:PutObject",
    ],
    resources = [
      "arn:aws:s3:::${var.region}-${var.aws_account_short_name}${var.kube_extra_id}-logs/*"
    ],
    principals = {
      type = "AWS",
      identifiers = [
        "${aws_iam_role.k8s-master.arn}",
        "${aws_iam_role.k8s-node.arn}"
      ]
    }
  }
}

resource "aws_s3_bucket" "logging" {
  bucket = "${var.region}-${var.aws_account_short_name}${var.kube_extra_id}-logs"
  acl    = "private"

  policy = "${data.aws_iam_policy_document.logging.json}"

  tags {
    Name              = "${var.region}-${var.aws_account_short_name}${var.kube_extra_id}-logs"
    pipeline_phase    = "${var.env}"
    service_component = "logs"
    region            = "${var.region}"
    KubernetesCluster = "${var.region}_${var.aws_account_short_name}${var.kube_extra_id}"
  }
}

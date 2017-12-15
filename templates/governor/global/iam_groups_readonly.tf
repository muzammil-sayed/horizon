resource "aws_iam_group" "data-readonly" {
  name = "data-readonly"
}

resource "aws_iam_group_policy" "data-readonly" {
  name  = "data-readonly"
  group = "${aws_iam_group.data-readonly.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::803429703521:role/readonly"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "microservices-readonly" {
  name = "microservices-readonly"
}

resource "aws_iam_group_policy" "microservices-readonly" {
  name  = "microservices-readonly"
  group = "${aws_iam_group.microservices-readonly.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::811034720611:role/readonly",
        "arn:aws:iam::193204500816:role/readonly",
        "arn:aws:iam::663559125979:role/readonly"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "reco-readonly" {
  name = "reco-readonly"
}

resource "aws_iam_group_policy" "reco-readonly" {
  name  = "reco-readonly"
  group = "${aws_iam_group.reco-readonly.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::870846026232:role/readonly",
        "arn:aws:iam::549229563172:role/readonly",
        "arn:aws:iam::642745549043:role/readonly"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "jcx-readonly" {
  name = "jcx-readonly"
}

resource "aws_iam_group_policy" "jcx-readonly" {
  name  = "jcx-readonly"
  group = "${aws_iam_group.jcx-readonly.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::811034720611:role/jcx-readonly",
        "arn:aws:iam::193204500816:role/jcx-readonly",
        "arn:aws:iam::663559125979:role/jcx-readonly"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "ps-readonly" {
  name = "ps-readonly"
}

resource "aws_iam_group_policy" "ps-readonly" {
  name  = "jcx-readonly"
  group = "${aws_iam_group.ps-readonly.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::044571148504:role/readonly",
        "arn:aws:iam::874979382819:role/readonly"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "infra-readonly" {
  name = "infra-readonly"
}

resource "aws_iam_group_policy" "infra-readonly" {
  name  = "infra-readonly"
  group = "${aws_iam_group.infra-readonly.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::517449413234:role/readonly",
        "arn:aws:iam::816602928515:role/readonly",
        "arn:aws:iam::403612517204:role/readonly"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "jive-w-readonly" {
  name = "jive-w-readonly"
}

resource "aws_iam_group_policy" "jive-w-readonly" {
  name  = "jive-w-readonly"
  group = "${aws_iam_group.jive-w-readonly.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::819473657664:role/readonly",
        "arn:aws:iam::704799964251:role/readonly",
        "arn:aws:iam::041205748055:role/readonly"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "partnercollaboration-readonly" {
  name = "partnercollaboration-readonly"
}

resource "aws_iam_group_policy" "partnercollaboration-readonly" {
  name  = "partnercollaboration-readonly"
  group = "${aws_iam_group.partnercollaboration-readonly.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::517449413234:role/readonly",
        "arn:aws:iam::816602928515:role/readonly",
        "arn:aws:iam::403612517204:role/readonly"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "support-readonly" {
  name = "support-readonly"
}

resource "aws_iam_group_policy" "support-readonly" {
  name  = "support-readonly"
  group = "${aws_iam_group.support-readonly.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::517449413234:role/readonly",
        "arn:aws:iam::816602928515:role/readonly",
        "arn:aws:iam::403612517204:role/readonly"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "ps-sandbox-readonly" {
  name = "ps-sandbox-readonly"
}

resource "aws_iam_group_policy" "ps-sandbox-readonly" {
  name  = "ps-sandbox-readonly"
  group = "${aws_iam_group.ps-sandbox-readonly.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::517449413234:role/readonly",
        "arn:aws:iam::816602928515:role/readonly",
        "arn:aws:iam::403612517204:role/readonly"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "hosting-pipeline-readonly" {
  name = "hosting-pipeline-readonly"
}

resource "aws_iam_group_policy" "hosting-pipeline-readonly" {
  name  = "hosting-pipeline-readonly"
  group = "${aws_iam_group.hosting-pipeline-readonly.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::293490559745:role/readonly"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "bikou-readonly" {
  name = "bikou-readonly"
}

resource "aws_iam_group_policy" "bikou-readonly" {
  name  = "bikou-readonly"
  group = "${aws_iam_group.bikou-readonly.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::417900408555:role/readonly"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "reco-sandbox-readonly" {
  name = "reco-sandbox-readonly"
}

resource "aws_iam_group_policy" "reco-sandbox-readonly" {
  name  = "reco-sandbox-readonly"
  group = "${aws_iam_group.reco-sandbox-readonly.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::922236644688:role/readonly"
      ]
    }
  ]
}
EOF
}


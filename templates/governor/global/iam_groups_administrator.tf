resource "aws_iam_group" "governor-administrator" {
  name = "governor-administrator"
}

resource "aws_iam_group_policy" "governor-administrator" {
  name  = "governor-administrator"
  group = "${aws_iam_group.governor-administrator.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:iam::236799202671:role/administrator"
    }
  ]
}
EOF
}

resource "aws_iam_group" "data-administrator" {
  name = "data-administrator"
}

resource "aws_iam_group_policy" "data-administrator" {
  name  = "data-administrator"
  group = "${aws_iam_group.data-administrator.id}"

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
        "arn:aws:iam::811034720611:role/data-administrator",
        "arn:aws:iam::193204500816:role/data-administrator",
        "arn:aws:iam::663559125979:role/data-administrator",
        "arn:aws:iam::999547976641:role/administrator",
        "arn:aws:iam::409573287771:role/administrator",
        "arn:aws:iam::467524913882:role/administrator"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "microservices-administrator" {
  name = "microservices-administrator"
}

resource "aws_iam_group_policy" "microservices-administrator" {
  name  = "microservices-administrator"
  group = "${aws_iam_group.microservices-administrator.id}"

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
        "arn:aws:iam::811034720611:role/administrator",
        "arn:aws:iam::193204500816:role/administrator",
        "arn:aws:iam::663559125979:role/administrator"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "reco-administrator" {
  name = "reco-administrator"
}

resource "aws_iam_group_policy" "reco-administrator" {
  name  = "reco-administrator"
  group = "${aws_iam_group.reco-administrator.id}"

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
        "arn:aws:iam::870846026232:role/administrator",
        "arn:aws:iam::549229563172:role/administrator",
        "arn:aws:iam::642745549043:role/administrator",
        "arn:aws:iam::403612517204:role/reco-administrator"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "jcx-administrator" {
  name = "jcx-administrator"
}

resource "aws_iam_group_policy" "jcx-administrator" {
  name  = "jcx-administrator"
  group = "${aws_iam_group.jcx-administrator.id}"

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
        "arn:aws:iam::811034720611:role/jcx-administrator",
        "arn:aws:iam::193204500816:role/jcx-administrator",
        "arn:aws:iam::663559125979:role/jcx-administrator"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "ps-administrator" {
  name = "ps-administrator"
}

resource "aws_iam_group_policy" "ps-administrator" {
  name  = "ps-administrator"
  group = "${aws_iam_group.ps-administrator.id}"

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
        "arn:aws:iam::044571148504:role/administrator",
        "arn:aws:iam::874979382819:role/administrator"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "infra-administrator" {
  name = "infra-administrator"
}

resource "aws_iam_group_policy" "infra-administrator" {
  name  = "infra-administrator"
  group = "${aws_iam_group.infra-administrator.id}"

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
        "arn:aws:iam::517449413234:role/administrator",
        "arn:aws:iam::816602928515:role/administrator",
        "arn:aws:iam::403612517204:role/administrator"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "cloudalytics-administrator" {
  name = "cloudalytics-administrator"
}

resource "aws_iam_group_policy" "cloudalytics-administrator" {
  name  = "cloudalytics-administrator"
  group = "${aws_iam_group.cloudalytics-administrator.id}"

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
        "arn:aws:iam::811034720611:role/cloudalytics-administrator",
        "arn:aws:iam::193204500816:role/cloudalytics-administrator",
        "arn:aws:iam::663559125979:role/cloudalytics-administrator"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "cloudsearch-administrator" {
  name = "cloudsearch-administrator"
}

resource "aws_iam_group_policy" "cloudsearch-administrator" {
  name  = "cloudsearch-administrator"
  group = "${aws_iam_group.cloudsearch-administrator.id}"

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
        "arn:aws:iam::811034720611:role/cloudsearch-administrator",
        "arn:aws:iam::663559125979:role/cloudsearch-administrator"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "tardis-administrator" {
  name = "tardis-administrator"
}

resource "aws_iam_group_policy" "tardis-administrator" {
  name  = "tardis-administrator"
  group = "${aws_iam_group.tardis-administrator.id}"

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
        "arn:aws:iam::811034720611:role/tardis-administrator",
        "arn:aws:iam::663559125979:role/tardis-administrator"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "baas-administrator" {
  name = "baas-administrator"
}

resource "aws_iam_group_policy" "baas-administrator" {
  name  = "baas-administrator"
  group = "${aws_iam_group.baas-administrator.id}"

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
        "arn:aws:iam::811034720611:role/baas-administrator",
        "arn:aws:iam::663559125979:role/baas-administrator"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "israel-administrator" {
  name = "israel-administrator"
}

resource "aws_iam_group_policy" "israel-administrator" {
  name  = "israel-administrator"
  group = "${aws_iam_group.israel-administrator.id}"

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
        "arn:aws:iam::811034720611:role/israel-administrator",
        "arn:aws:iam::193204500816:role/israel-administrator",
        "arn:aws:iam::663559125979:role/israel-administrator",
        "arn:aws:iam::517449413234:role/administrator",
        "arn:aws:iam::403612517204:role/administrator"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "mako-administrator" {
  name = "mako-administrator"
}

resource "aws_iam_group_policy" "mako-administrator" {
  name  = "mako-administrator"
  group = "${aws_iam_group.mako-administrator.id}"

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
        "arn:aws:iam::811034720611:role/mako-administrator",
        "arn:aws:iam::193204500816:role/mako-administrator",
        "arn:aws:iam::663559125979:role/mako-administrator"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "jive-w-administrator" {
  name = "jive-w-administrator"
}

resource "aws_iam_group_policy" "jive-w-administrator" {
  name  = "jive-w-administrator"
  group = "${aws_iam_group.jive-w-administrator.id}"

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
        "arn:aws:iam::819473657664:role/administrator",
        "arn:aws:iam::704799964251:role/administrator",
        "arn:aws:iam::041205748055:role/administrator"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "partnercollaboration-administrator" {
  name = "partnercollaboration-administrator"
}

resource "aws_iam_group_policy" "partnercollaboration-administrator" {
  name  = "partnercollaboration-administrator"
  group = "${aws_iam_group.partnercollaboration-administrator.id}"

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
        "arn:aws:iam::803429703521:role/administrator"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "support-administrator" {
  name = "support-administrator"
}

resource "aws_iam_group_policy" "support-administrator" {
  name  = "support-administrator"
  group = "${aws_iam_group.support-administrator.id}"

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
        "arn:aws:iam::728487378642:role/administrator"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "ps-sandbox-administrator" {
  name = "ps-sandbox-administrator"
}

resource "aws_iam_group_policy" "ps-sandbox-administrator" {
  name  = "ps-sandbox-administrator"
  group = "${aws_iam_group.ps-sandbox-administrator.id}"

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
        "arn:aws:iam::042966178169:role/administrator"
      ]
    }
  ]
}
EOF
}


resource "aws_iam_group" "hosting-pipeline-administrator" {
  name = "hosting-pipeline-administrator"
}

resource "aws_iam_group_policy" "hosting-pipeline-administrator" {
  name  = "hosting-pipeline-administrator"
  group = "${aws_iam_group.hosting-pipeline-administrator.id}"

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
        "arn:aws:iam::293490559745:role/administrator"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "bikou-administrator" {
  name = "bikou-administrator"
}

resource "aws_iam_group_policy" "bikou-administrator" {
  name  = "bikou-administrator"
  group = "${aws_iam_group.bikou-administrator.id}"

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
        "arn:aws:iam::417900408555:role/administrator"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "reco-sandbox-administrator" {
  name = "reco-sandbox-administrator"
}

resource "aws_iam_group_policy" "reco-sandbox-administrator" {
  name  = "reco-sandbox-administrator"
  group = "${aws_iam_group.reco-sandbox-administrator.id}"

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
        "arn:aws:iam::922236644688:role/administrator"
      ]
    }
  ]
}
EOF
}


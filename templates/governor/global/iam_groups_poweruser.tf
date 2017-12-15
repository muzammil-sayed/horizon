resource "aws_iam_group" "data-poweruser" {
  name = "data-poweruser"
}

resource "aws_iam_group_policy" "data-poweruser" {
  name  = "data-poweruser"
  group = "${aws_iam_group.data-poweruser.id}"

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
        "arn:aws:iam::803429703521:role/poweruser"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "microservices-poweruser" {
  name = "microservices-poweruser"
}

resource "aws_iam_group_policy" "microservices-poweruser" {
  name  = "microservices-poweruser"
  group = "${aws_iam_group.microservices-poweruser.id}"

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
        "arn:aws:iam::811034720611:role/poweruser",
        "arn:aws:iam::193204500816:role/poweruser",
        "arn:aws:iam::663559125979:role/poweruser"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "reco-poweruser" {
  name = "reco-poweruser"
}

resource "aws_iam_group_policy" "reco-poweruser" {
  name  = "reco-poweruser"
  group = "${aws_iam_group.reco-poweruser.id}"

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
        "arn:aws:iam::870846026232:role/poweruser",
        "arn:aws:iam::549229563172:role/poweruser",
        "arn:aws:iam::642745549043:role/poweruser"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "jcx-poweruser" {
  name = "jcx-poweruser"
}

resource "aws_iam_group_policy" "jcx-poweruser" {
  name  = "jcx-poweruser"
  group = "${aws_iam_group.jcx-poweruser.id}"

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
        "arn:aws:iam::811034720611:role/jcx-poweruser",
        "arn:aws:iam::193204500816:role/jcx-poweruser",
        "arn:aws:iam::663559125979:role/jcx-poweruser"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "ps-poweruser" {
  name = "ps-poweruser"
}

resource "aws_iam_group_policy" "ps-poweruser" {
  name  = "jcx-poweruser"
  group = "${aws_iam_group.ps-poweruser.id}"

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
        "arn:aws:iam::044571148504:role/poweruser",
        "arn:aws:iam::874979382819:role/poweruser"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "infra-poweruser" {
  name = "infra-poweruser"
}

resource "aws_iam_group_policy" "infra-poweruser" {
  name  = "infra-poweruser"
  group = "${aws_iam_group.infra-poweruser.id}"

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
        "arn:aws:iam::517449413234:role/poweruser",
        "arn:aws:iam::816602928515:role/poweruser",
        "arn:aws:iam::403612517204:role/poweruser"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "jive-w-poweruser" {
  name = "jive-w-poweruser"
}

resource "aws_iam_group_policy" "jive-w-poweruser" {
  name  = "jive-w-poweruser"
  group = "${aws_iam_group.jive-w-poweruser.id}"

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
        "arn:aws:iam::819473657664:role/poweruser",
        "arn:aws:iam::704799964251:role/poweruser",
        "arn:aws:iam::041205748055:role/poweruser"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "partnercollaboration-poweruser" {
  name = "partnercollaboration-poweruser"
}

resource "aws_iam_group_policy" "partnercollaboration-poweruser" {
  name  = "partnercollaboration-poweruser"
  group = "${aws_iam_group.partnercollaboration-poweruser.id}"

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
        "arn:aws:iam::517449413234:role/poweruser",
        "arn:aws:iam::816602928515:role/poweruser",
        "arn:aws:iam::403612517204:role/poweruser"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "support-poweruser" {
  name = "support-poweruser"
}

resource "aws_iam_group_policy" "support-poweruser" {
  name  = "support-poweruser"
  group = "${aws_iam_group.support-poweruser.id}"

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
        "arn:aws:iam::517449413234:role/poweruser",
        "arn:aws:iam::816602928515:role/poweruser",
        "arn:aws:iam::403612517204:role/poweruser"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "ps-sandbox-poweruser" {
  name = "ps-sandbox-poweruser"
}

resource "aws_iam_group_policy" "ps-sandbox-poweruser" {
  name  = "ps-sandbox-poweruser"
  group = "${aws_iam_group.ps-sandbox-poweruser.id}"

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
        "arn:aws:iam::517449413234:role/poweruser",
        "arn:aws:iam::816602928515:role/poweruser",
        "arn:aws:iam::403612517204:role/poweruser"
      ]
    }
  ]
}
EOF
}


resource "aws_iam_group" "hosting-pipeline-poweruser" {
  name = "hosting-pipeline-poweruser"
}

resource "aws_iam_group_policy" "hosting-pipeline-poweruser" {
  name  = "hosting-pipeline-poweruser"
  group = "${aws_iam_group.hosting-pipeline-poweruser.id}"

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
        "arn:aws:iam::293490559745:role/poweruser"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "bikou-poweruser" {
  name = "bikou-poweruser"
}

resource "aws_iam_group_policy" "bikou-poweruser" {
  name  = "bikou-poweruser"
  group = "${aws_iam_group.bikou-poweruser.id}"

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
        "arn:aws:iam::417900408555:role/poweruser"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group" "reco-sandbox-poweruser" {
  name = "reco-sandbox-poweruser"
}

resource "aws_iam_group_policy" "reco-sandbox-poweruser" {
  name  = "reco-sandbox-poweruser"
  group = "${aws_iam_group.reco-sandbox-poweruser.id}"

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
        "arn:aws:iam::922236644688:role/poweruser"
      ]
    }
  ]
}
EOF
}


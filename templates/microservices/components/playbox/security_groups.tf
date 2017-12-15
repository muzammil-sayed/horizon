resource "aws_security_group" "playbox_common" {
  name        = "${var.env}-playbox_common"
  description = "Common permissions"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [
      "${var.infra_pipeline_inst_sg}"
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "playbox_mongodb_data" {
  name        = "${var.env}-playbox_mongodb_data"
  description = "Access to Playbox MongoDB data nodes"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    security_groups = [
      "${var.pipeline_inst_sg}",
      "${var.infra_pipeline_inst_sg}",
    ]
    cidr_blocks = ["0.0.0.0/0"] #Temporary
    self = true
  }

  tags {
    Name              = "${var.env}-playbox-mongodb-data"
    Pipeline_Phase    = "${var.env}"
    Jive_Service      = "${var.jive_service}"
    Service_Component = "mongodb"
  }
}


resource "aws_security_group" "playbox_redis" {
  name        = "${var.env}-playbox-redis"
  description = "Access to Playbox Redis nodes"
  vpc_id      = "${var.aws_vpc_main}"
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [
      "${var.infra_pipeline_inst_sg}",
      "${var.pipeline_inst_sg}"
    ]
  }

  tags {
    Name              = "${var.env}-playbox-redis"
    Pipeline_Phase    = "${var.env}"
    Jive_Service      = "${var.jive_service}"
    Service_Component = "redis"
  }
}

resource "aws_security_group" "playbox_zookeeper" {
  name        = "${var.env}-playbox_zookeeper"
  description = "Access to Playbox zookeeper nodes"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    self = true
  }

  tags {
    Name              = "${var.env}-playbox-zookeeper"
    Pipeline_Phase    = "${var.env}"
    Jive_Service      = "${var.jive_service}"
    Service_Component = "zookeeper"
  }
}


resource "aws_security_group" "playbox_nimbus" {
  name        = "${var.env}-playbox_nimbus"
  description = "Access to Playbox Storm Nimbus"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [
      "${var.pipeline_inst_sg}",
      "${var.infra_pipeline_inst_sg}",
    ]
  }

  tags {
    Name              = "${var.env}-playbox-nimbus"
    Pipeline_Phase    = "${var.env}"
    Jive_Service      = "${var.jive_service}"
    Service_Component = "nimbus"
  }
}

resource "aws_security_group" "playbox_supervisor" {
  name        = "${var.env}-playbox_supervisor"
  description = "Access to Playbox Storm Nimbus"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    security_groups = [
      "${var.pipeline_inst_sg}",
      "${var.infra_pipeline_inst_sg}",
    ]
    self = true
  }

  tags {
    Name              = "${var.env}-playbox-supervisor"
    Pipeline_Phase    = "${var.env}"
    Jive_Service      = "${var.jive_service}"
    Service_Component = "supervisor"
  }
}

resource "aws_security_group" "fileservice_mysql" {
  name        = "${var.env}-fileservice_mysql"
  description = "Access to fileservice_mysql (${var.env})"
  vpc_id      = "${var.aws_vpc_main}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.fileservice_ingress_cidr_blocks}"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion_cidr}"]
  }

  tags {
    Name              = "${var.env}-fileservice_mysql"
    Pipeline_Phase    = "${var.env}"
    Jive_Service      = "${var.jive_service}"
  }
}

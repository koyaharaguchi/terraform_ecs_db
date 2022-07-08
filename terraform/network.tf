module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  cidr           = "10.0.0.0/16"
  azs            = ["ap-northeast-1a"]
  public_subnets = ["10.0.0.0/24"]

}

resource "aws_security_group" "db" {
  name   = "db"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "db_ingress" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db.id
}

resource "aws_security_group_rule" "db_egress" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db.id
}

resource "aws_security_group" "ssh" {
  name   = "ssh"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ssh.id
}

resource "aws_security_group_rule" "ssh_egress" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ssh.id
}

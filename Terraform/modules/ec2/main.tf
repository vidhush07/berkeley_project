locals {
  interface_endpoints = [
    "com.amazonaws.${var.region}.eks",
    "com.amazonaws.${var.region}.sts",
    "com.amazonaws.${var.region}.ec2",
    "com.amazonaws.${var.region}.ec2messages",
    "com.amazonaws.${var.region}.ecr.api",
    "com.amazonaws.${var.region}.ecr.dkr",
    "com.amazonaws.${var.region}.elasticloadbalancing",
    "com.amazonaws.${var.region}.logs",
  ]
}



resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id
  name   = var.sg_name

  # No inbound needed for SSM!
  ingress = []

}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id
  ip_protocol       = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_endpoint" "interface_endpoints" {
  for_each            = toset(local.interface_endpoints)
  vpc_id              = var.vpc_id
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnets
  security_group_ids  = [aws_security_group.ec2_sg.id]
  private_dns_enabled = true
}



resource "aws_instance" "ec2" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instancetype
  subnet_id              = var.ec2_subnetid
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  associate_public_ip_address = false


  tags = {
    Name = "gitlab-server"
  }
}

resource "aws_ec2_instance_connect_endpoint" "eic" {
  subnet_id = var.ec2_subnetid

  security_group_ids = [
    aws_security_group.ec2_sg.id
  ]
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_private_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_eks" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "ec2_sts" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_private_profile"
  role = aws_iam_role.ec2_role.name
}
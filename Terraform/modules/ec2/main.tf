resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id
  name   = var.sg_name

  # No inbound needed for SSM!
  ingress = []

}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = var.vpc_cidrs
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_instance" "ec2" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instancetype
  subnet_id              = var.ec2_subnetid
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  associate_public_ip_address = false


  tags = {
    Name = "session-manager-ec2"
  }
}

resource "aws_ec2_instance_connect_endpoint" "eic" {
  subnet_id = var.ec2_subnetid

  security_group_ids = [
    aws_security_group.ec2_sg.id
  ]
}

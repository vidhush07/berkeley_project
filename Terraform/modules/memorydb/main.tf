resource "aws_security_group" "memorydb_sg" {
  name        = var.memorydb_name
  description = "Allow inbound Redis traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidrs # restrict to VPC / private CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_memorydb_subnet_group" "dbredis_subgrp" {
  name       = "${var.memorydb_name}-subnet-group"
  subnet_ids = var.private_subnet_ids
}


resource "aws_memorydb_cluster" "this" {
  name               = var.memorydb_name
  engine_version     = var.engine_version
  node_type          = var.node_type
  num_shards         = 1
  num_replicas_per_shard = 1
  snapshot_retention_limit = 0

  acl_name           = "open-access"   # or use custom ACL
  subnet_group_name  = aws_memorydb_subnet_group.dbredis_subgrp.name
  security_group_ids = [aws_security_group.memorydb_sg.id]

  maintenance_window = "sun:03:00-sun:04:00"
}


data "aws_region" "current" {}

resource "aws_vpc_endpoint" "memorydb" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.memory-db"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [
    aws_security_group.memorydb_sg.id
  ]

  private_dns_enabled = true
}

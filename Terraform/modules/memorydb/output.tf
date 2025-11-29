output "memorydb_endpoint" {
  value = aws_memorydb_cluster.this.cluster_endpoint[0].address
}

output "memorydb_port" {
  value = aws_memorydb_cluster.this.cluster_endpoint[0].port
}

output "memorydb_vpc_endpoint_id" {
  value = aws_vpc_endpoint.memorydb.id
}
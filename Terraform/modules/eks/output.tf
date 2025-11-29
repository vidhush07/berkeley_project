output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_certificate_authority" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "node_group_names" {
  value = [for ng in aws_eks_node_group.ng : ng.node_group_name]
}

output "vpc_interface_endpoints" {
  value = { for k, v in aws_vpc_endpoint.interface_endpoints : k => v.id }
}

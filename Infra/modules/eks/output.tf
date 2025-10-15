output "eks_cluster_id" {
  value = aws_eks_cluster.cluster.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "eks_node_group_arn" {
  value = aws_eks_node_group.node_group.arn
}

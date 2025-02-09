output "cluster_id" {
  value = aws_eks_cluster.example.id
}

output "node_group_id" {
  value = aws_eks_node_group.example.id
}

output "cluster_name" {
  value = aws_eks_cluster.example.name
}
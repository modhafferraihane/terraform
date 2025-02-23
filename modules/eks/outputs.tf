output "cluster_id" {
  value = aws_eks_cluster.example.id
}

output "node_group_id" {
  value = aws_eks_node_group.example.id
}

output "cluster_name" {
  value = aws_eks_cluster.example.name
}

output "host" {
  value = aws_eks_cluster.example.endpoint
  
}
output "certificate_authority" {
  value = aws_eks_cluster.example.certificate_authority.0.data
}

output "external_dns_role_arn" {
  value = aws_iam_role.external_dns_role.arn 
  
}
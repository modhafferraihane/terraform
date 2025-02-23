

output "cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

# output "external_dns_role_arn" {
#   value = aws_iam_role.external_dns_role.arn
# }
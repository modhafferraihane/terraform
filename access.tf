# Référence au groupe IAM existant "admins"
data "aws_iam_group" "admins" {
  group_name = "admins"
}
locals {
  devops_users= data.aws_iam_group.admins.users[*].arn
  eks_access_entries_devops = flatten([
    for cluster in var.eks_clusters : [
      for user_arn in local.devops_users : {
        cluster_name  = cluster
        principal_arn = user_arn
      }
    ]
  ])

} 

resource "aws_eks_access_entry" "devops" {
  for_each = { for idx, entry in local.eks_access_entries_devops : idx => entry }
  cluster_name  = each.value.cluster_name
  principal_arn = each.value.principal_arn

  depends_on = [aws_eks_cluster.example]
}

resource "aws_eks_access_policy_association" "devops" {
  for_each = { for idx, entry in local.eks_access_entries_devops : idx => entry }

  cluster_name  = each.value.cluster_name
  principal_arn = each.value.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.devops]
}
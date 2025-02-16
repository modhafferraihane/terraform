# Référence au groupe IAM existant "admins"


resource "aws_eks_access_entry" "devops" {
  for_each = { for idx, entry in var.eks_access_entries_admins : idx => entry }
  cluster_name  = each.value.cluster_name
  principal_arn = each.value.principal_arn
}

resource "aws_eks_access_policy_association" "devops" {
  for_each = { for idx, entry in var.eks_access_entries_admins : idx => entry }

  cluster_name  = each.value.cluster_name
  principal_arn = each.value.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.devops]
}
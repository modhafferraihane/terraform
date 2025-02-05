# Référence au groupe IAM existant "admins"
data "aws_iam_group" "admins" {
  group_name = "admins"
}


resource "aws_eks_access_entry" "devops" {
  for_each = { for idx, entry in local.eks_access_entries_devops : idx => entry }
  cluster_name  = each.value.cluster_name
  principal_arn = each.value.principal_arn
}


resource "aws_eks_access_policy_association" "devops" {
  for_each = { for cluser, user in local.eks_access_entries_devops : cluser => user }

  cluster_name  = each.value.cluster_name
  principal_arn = each.value.principal_arn
  policy_arn    = var.eks_access_policies.cluster_admin

  access_scope {
    type = "cluster"
  }
}
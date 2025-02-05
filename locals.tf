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
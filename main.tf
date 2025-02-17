# VPC module
module "networking" {
source = "./modules/networking"
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  cidr_block = var.cidr_vpc
}

# IAM module
module "iam" {
  source           = "./modules/iam"
  cluster_role_name = "eks-cluster-role"
  node_role_name    = "eks-node-role"
  depends_on = [ module.networking ]
}

data "aws_iam_group" "admins" {
  group_name = "admins"
}

locals {
  devops_users= data.aws_iam_group.admins.users[*].arn
  eks_access_entries_devops = flatten([
      for user_arn in local.devops_users : {
        cluster_name  = var.eks_cluster_name
        principal_arn = user_arn
      }
    ]
  )

}

# EKS module
module "eks" {
  source           = "./modules/eks"
  eks_cluster_name = var.eks_cluster_name
  node_group_name = "ops-node-group"
  subnet_ids = module.networking.private_subnet_ids
  desired_size     = 1
  max_size         = 3
  min_size         = 1
  node_role_arn = module.iam.node_role_arn
  eks_access_entries_admins = local.eks_access_entries_devops
  cluster_role_arn = module.iam.cluster_role_arn
  depends_on = [ module.iam ]
}



# module "eks_access" {
#   source           = "./modules/eks_access"
#   eks_access_entries_admins = local.eks_access_entries_devops
#   depends_on = [ module.eks.cluster ]
# }
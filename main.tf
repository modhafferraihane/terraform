# IAM module
module "iam" {
  source           = "./modules/iam"
  cluster_role_name = "eks-cluster-role"
  node_role_name    = "eks-node-role"
}

# EKS module
module "eks" {
  source           = "./modules/eks"
  eks_cluster_names = var.eks_cluster_names
  node_group_name = "ops-node-group"
  subnet_ids       = [for subnet in aws_subnet.subnet : subnet.id]
  desired_size     = 1
  max_size         = 3
  min_size         = 1
}







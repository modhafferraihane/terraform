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
  cluster_role_arn = aws_iam_role.eks_cluster_role.arn
  node_role_arn    = aws_iam_role.eks_node_role.arn
  subnet_ids       = [for subnet in aws_subnet.subnet : subnet.id]
  desired_size     = 1
  max_size         = 3
  min_size         = 1
}







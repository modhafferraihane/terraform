

resource "aws_eks_cluster" "example" {
  name     = var.eks_cluster_name
  role_arn = var.cluster_role_arn
  version  = "1.32"

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }
  vpc_config {
    subnet_ids = var.subnet_ids
  }
}


resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = var.node_group_name
  node_role_arn   = var.cluster_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }
  depends_on = [aws_eks_cluster.example]
}

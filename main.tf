
# # VPC module
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

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
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
resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = <<EOT
aws eks update-kubeconfig --name ${var.eks_cluster_name} --region ${var.region}
kubectl config set-context arn:aws:eks:${var.region}:${local.account_id}:cluster/${var.eks_cluster_name} --cluster arn:aws:eks:${var.region}:${local.account_id}:cluster/${var.eks_cluster_name} --user arn:aws:eks:${var.region}:${local.account_id}:cluster/${var.eks_cluster_name}
kubectl config use-context arn:aws:eks:${var.region}:${local.account_id}:cluster/${var.eks_cluster_name}
EOT
  }

  depends_on = [module.eks]
}

resource "null_resource" "apply_grafana_service" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/kube-prometheus-stack-grafana.yml"
  }

  depends_on = [null_resource.update_kubeconfig]
}

resource "aws_iam_policy" "external_dns_policy" {
  name        = "ExternalDNSPolicy"
  description = "Policy for ExternalDNS to access Route53"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "external_dns_role" {
  name = "ExternalDNSRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_dns_policy_attachment" {
  role       = aws_iam_role.external_dns_role.name
  policy_arn = aws_iam_policy.external_dns_policy.arn
}
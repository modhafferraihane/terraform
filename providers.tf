terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.1"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" 
}

data "aws_eks_cluster" "example" {
  name = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "example" {
  name = data.aws_eks_cluster.example.name
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.example.token
}
/*
resource "kubernetes_manifest" "grafana_service" {
  manifest = yamldecode(file("${path.module}/kube-prometheus-stack-grafana.yml"))
}*/

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.example.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.example.token
  }
} 

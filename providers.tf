terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
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

provider "helm" {
  kubernetes = {
  host                   = data.aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.example.token
}
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.example.token
}

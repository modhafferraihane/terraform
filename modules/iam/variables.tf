variable "cluster_role_name" {
  description = "Name of the IAM role for the EKS cluster"
  type        = string
  default     = "eks-cluster-role"
}

variable "node_role_name" {
  description = "Name of the IAM role for the EKS node group"
  type        = string
  default     = "eks-node-role"
}
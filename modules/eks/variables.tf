variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "eks_cluster_names" {
  description = "EKS cluster name"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "EKS cluster role ARN"
  type        = string
}

variable "node_group_name" {
  description = "EKS node group name"
  type        = string
}

variable "node_role_arn" {
  description = "EKS node role ARN"
  type        = string
}


variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}


variable "eks_access_scope" {
  description = "EKS Namespaces for teams to grant access with aws_eks_access_policy_association"
  type = map(object({
    namespaces_admin     = optional(set(string)),
    namespaces_edit      = optional(set(string)),
    namespaces_read_only = optional(set(string))
  }))
  default = {
    backend = {
      namespaces_edit      = ["*backend*", "*session-notes*"],
      namespaces_read_only = ["*ops*"]
    },
    qa = {
      namespaces_edit      = ["*qa*"],
      namespaces_read_only = ["*backend*"]
    }
  }
}


variable "eks_access_policies" {
  description = "List of EKS clusters to create records"
  type = map(string)
  default = {
    cluster_admin = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy",
    namespace_admin = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy",
    namespace_edit = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy",
    namespace_read_only = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy",
  }
}
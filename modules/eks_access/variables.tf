variable "eks_access_entries_admins" {
  description = "List of EKS clusters to create records"
  type = list(object({
    cluster_name  = string
    principal_arn = string
  })
  ) 
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
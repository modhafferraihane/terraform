variable "eks_clusters" {
  description = "List of EKS clusters to create records"
  type = set(string)
  default = [
    "ops-cluster"
  ]
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

variable "subnets" {
  description = "List of subnets"
  type = list(object({
    cidr_block        = string
    availability_zone = string
    name              = string
    type              = string
  }))
  default = [
    {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
      name              = "public-subnet-1"
      type              = "public"
    },
    {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
      name              = "public-subnet-2"
      type              = "public"
    },
    {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1a"
      name              = "private-subnet-1"
      type              = "private"
    },
    {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-1b"
      name              = "private-subnet-2"
      type              = "private"
    }
  ]
}
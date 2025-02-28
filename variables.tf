variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "ops-cluster"
}

variable "public_subnets" {
  description = "List of public subnets"
  type = list(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))
  default = [
    {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
      name              = "public-subnet-1"
    },
    {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
      name              = "public-subnet-2"
    }
  ]
}

variable "private_subnets" {
  description = "List of private subnets"
  type = list(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))
  default = [
    {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1a"
      name              = "private-subnet-1"
    },
    {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-1b"
      name              = "private-subnet-2"
    }
  ]
}

variable "cidr_vpc" {
  type = string
  default = "10.0.0.0/16"
}

variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

# variable "account_id" {
#   description = "The AWS account ID"
#   type        = string
# }

# variable "github_client_id" {
#   description = "The GitHub OAuth client ID"
#   type        = string
# }

# variable "github_client_secret" {
#   description = "The GitHub OAuth client secret"
#   type        = string
#   sensitive   = true
# }
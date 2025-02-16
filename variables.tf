variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "ops-cluster"
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

variable "cidr_vpc" {
  type = string
  default = "10.0.0.0/16"
}
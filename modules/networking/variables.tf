variable "public_subnets" {
  description = "List of public subnets"
  type = list(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))
}

variable "private_subnets" {
  description = "List of private subnets"
  type = list(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type = string

}
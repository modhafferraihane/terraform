variable "subnets" {
  description = "List of subnets"
  type = list(object({
    cidr_block        = string
    availability_zone = string
    name              = string
    type              = string
  }))
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type = string

}
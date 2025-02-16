# create vpc
resource "aws_vpc" "example" {
  cidr_block = var.cidr_block

  tags = {
    Name = "example-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example-igw"
  }
}

# Subnets
resource "aws_subnet" "subnet" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  vpc_id            = aws_vpc.example.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = each.value.type == "public" ? true : false
  
  tags = {
    Name = each.value.name
    Type = each.value.type
  }
  depends_on = [ aws_internet_gateway.igw ]
}

# Elastic IP
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  depends_on = [ aws_subnet.subnet]
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet["public-subnet-1"].id
}

# Route Tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-rt"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public_rt_assoc_1" {
  subnet_id      = aws_subnet.subnet["public-subnet-1"].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_2" {
  subnet_id      = aws_subnet.subnet["public-subnet-2"].id
  route_table_id = aws_route_table.public_rt.id
}

# Security Groups
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.example.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-sg"
  }
}

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.example.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg"
  }
}
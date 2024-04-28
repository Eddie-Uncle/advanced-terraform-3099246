# AWS Provider Configuration
provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "default" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "default"
  }
}

# Subnet
resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.default.id
  cidr_block = var.subnet_cidr
  tags = {
    Name = var.subnet_name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

# Route Table
resource "aws_route_table" "default" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.default.id
}

# Security Group to allow ICMP
resource "aws_security_group" "default" {
  name        = "test-firewall"
  description = "Allow ICMP"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
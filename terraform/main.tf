provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "cloudlaunch" {
  cidr_block = var.vpc_cidr
  tags = { Name = "${var.prefix}-vpc" }
}

# Public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.cloudlaunch.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = { Name = "${var.prefix}-public-subnet" }
}

# Application subnet
resource "aws_subnet" "app" {
  vpc_id     = aws_vpc.cloudlaunch.id
  cidr_block = var.app_subnet_cidr
  tags = { Name = "${var.prefix}-app-subnet" }
}

# Database subnet
resource "aws_subnet" "db" {
  vpc_id     = aws_vpc.cloudlaunch.id
  cidr_block = var.db_subnet_cidr
  tags = { Name = "${var.prefix}-db-subnet" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cloudlaunch.id
  tags = { Name = "${var.prefix}-igw" }
}

# Route table for public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.cloudlaunch.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.prefix}-public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security group for app
resource "aws_security_group" "app_sg" {
  vpc_id = aws_vpc.cloudlaunch.id
  name   = "${var.prefix}-app-sg"

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
}

# Security group for db
resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.cloudlaunch.id
  name   = "${var.prefix}-db-sg"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

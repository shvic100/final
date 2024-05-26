# AWS 제공자 설정
provider "aws" {
  region = "ap-northeast-1"
}

# VPC 및 서브넷 리소스 생성
resource "aws_vpc" "EOF_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    Name = "EOF-vpc"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.EOF_vpc.id
  cidr_block              = var.public_subnet_a_cidr
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
  tags = {
    Name = "EOF-public-a"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.EOF_vpc.id
  cidr_block              = var.public_subnet_c_cidr
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1c"
  tags = {
    Name = "EOF-public-c"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.EOF_vpc.id
  cidr_block              = var.private_subnet_a_cidr
  map_public_ip_on_launch = false
  availability_zone       = "ap-northeast-1a"
  tags = {
    Name = "EOF-private-a"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id                  = aws_vpc.EOF_vpc.id
  cidr_block              = var.private_subnet_c_cidr
  map_public_ip_on_launch = false
  availability_zone       = "ap-northeast-1c"
  tags = {
    Name = "EOF-private-c"
  }
}

resource "aws_internet_gateway" "EOF_igw" {
  vpc_id = aws_vpc.EOF_vpc.id
  tags = {
    Name = "EOF-internet-gateway"
  }
}

resource "aws_default_route_table" "public_route_table" {
  default_route_table_id = aws_vpc.EOF_vpc.default_route_table_id
  tags = {
    Name = "EOF-public-route-table"
  }
}

resource "aws_route" "internet_gw_route" {
  route_table_id         = aws_vpc.EOF_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.EOF_igw.id
}

resource "aws_eip" "EOF_NAT_EIP" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.EOF_igw]
}

resource "aws_nat_gateway" "EOF_NAT_gateway" {
  allocation_id = aws_eip.EOF_NAT_EIP.id
  subnet_id     = aws_subnet.public_a.id
  depends_on    = [aws_internet_gateway.EOF_igw]
  tags = {
    Name = "EOF-NAT-gateway"
  }
}

resource "aws_route_table" "EOF_private_route_table" {
  vpc_id = aws_vpc.EOF_vpc.id
  tags = {
    Name = "EOF-private-route-table"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.EOF_private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.EOF_NAT_gateway.id
}

resource "aws_route_table_association" "public_subneta_association" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_vpc.EOF_vpc.main_route_table_id
}

resource "aws_route_table_association" "public_subnetb_association" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_vpc.EOF_vpc.main_route_table_id
}

resource "aws_route_table_association" "private_subneta_association" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.EOF_private_route_table.id
}

resource "aws_route_table_association" "private_subnetb_association" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.EOF_private_route_table.id
}


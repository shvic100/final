variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "public_subnet_a_cidr" {
  description = "CIDR block for public subnet A"
  type        = string
}

variable "public_subnet_a_name" {
  description = "Name of public subnet A"
  type        = string
}

variable "public_subnet_a_az" {
  description = "Availability zone for public subnet A"
  type        = string
}

variable "public_subnet_c_cidr" {
  description = "CIDR block for public subnet C"
  type        = string
}

variable "public_subnet_c_name" {
  description = "Name of public subnet C"
  type        = string
}

variable "public_subnet_c_az" {
  description = "Availability zone for public subnet C"
  type        = string
}

variable "private_subnet_a_cidr" {
  description = "CIDR block for private subnet A"
  type        = string
}

variable "private_subnet_a_name" {
  description = "Name of private subnet A"
  type        = string
}

variable "private_subnet_a_az" {
  description = "Availability zone for private subnet A"
  type        = string
}

variable "private_subnet_c_cidr" {
  description = "CIDR block for private subnet C"
  type        = string
}

variable "private_subnet_c_name" {
  description = "Name of private subnet C"
  type        = string
}

variable "private_subnet_c_az" {
  description = "Availability zone for private subnet C"
  type        = string
}

variable "internet_gateway_name" {
  description = "Name of the internet gateway"
  type        = string
}

variable "public_route_table_name" {
  description = "Name of the public route table"
  type        = string
}

variable "nat_gateway_name" {
  description = "Name of the NAT gateway"
  type        = string
}

variable "private_route_table_name" {
  description = "Name of the private route table"
  type        = string
}

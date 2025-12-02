variable "subnet_public_id" {
  type = string
  description = "Public Subnet ID for Nat Gateway"
}

variable "subnet_private_id" {
  type = string
  description = "Private Subnet ID to route to NAT Gateway"
}

variable "vpc_id" {
  type = string
  description = "VPC ID"
}

variable "route_table_public_id" {
  type = string
  description = "Route Table ID for public subnet"
}

variable "igw_vpc_id" {
  type = string
  description = "IGW ID"
}

variable "route_table_private_id" {
  type = string
  description = "Route Table ID for private subnet"
}
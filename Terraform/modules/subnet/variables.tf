variable "vpc_id" {
  type        = string
  description = "VPC ID to create subnets in"
}

variable "public_cidrs" {
  type        = list(string)
  description = "List of CIDRs for public subnets"
}

variable "private_cidrs" {
  type        = list(string)
  description = "List of CIDRs for private subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "Matching AZs for subnets"
}

variable "internetgateway_id" {
  type = string
  description = "Name of the internet gateway"
}
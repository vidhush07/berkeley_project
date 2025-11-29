variable "vpc_id" {
  type        = string
  description = "VPC ID to create subnets in"
}

variable "private_cidrs" {
  type        = list(string)
  description = "List of CIDRs for private subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "Matching AZs for subnets"
}

variable "cluster_name" {
  type    = string
  default = "eks-private-cluster"
}

variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
  # Expect exactly 3 subnets (one per AZ)
}

variable "private_subnet_azs" {
  type = list(string)
  # e.g. ["ap-southeast-1a","ap-southeast-1b","ap-southeast-1c"]
}

variable "vpc_cidrs" {
  type = list(string)
}

variable "sg_name" {
  type = string
  description = "Security Group name for the ec2"
}
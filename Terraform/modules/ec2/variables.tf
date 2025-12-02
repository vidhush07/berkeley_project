variable "ec2_ami" {
  type = string
  description = "AMI"
}

variable "ec2_instancetype" {
  type = string
  description = "Instance Type for the Ec2"
}

variable "sg_name" {
  type = string
  description = "Security Group name for the ec2"
}

variable "vpc_cidrs" {
  type = string
  description = "VPC Cidrs"
}

variable "ec2_subnetid" {
  type = string
  description = "Subnet ID for the Ec2"
}

variable "vpc_id" {
  type = string
  description = "VPC ID"
}

variable "private_subnets" {
  type = list(string)
}

variable "region" {
  type = string
}

variable "route_table_ids" {
  type = list(string)
  description = "Route table to S3 gateway assoc"
}

variable "user_data" {
  type = string
  description = "User Data"
}
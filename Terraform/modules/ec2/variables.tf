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
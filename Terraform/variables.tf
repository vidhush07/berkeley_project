variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "env" {
  type    = string
  default = "prod"
}

variable "vpc_cidrs" {
  type = map(string)
  default = {
    ingress = "10.10.0.0/16"
    production = "10.20.0.0/16"
    common = "10.30.0.0/16"
    jumphost = "10.40.0.0/24"
  }
}

variable "availability_zones" {
  type = list(string)
  default = ["ap-southeast-1a","ap-southeast-1b","ap-southeast-1c"]
}

variable "bucket_name" {
  type = string
  default = "stgbuckets3"
}

variable "bucket_tfstate_key" {
    type = string
    default = "tfstatekey"
}

variable "myip" {
    type = string
    default = "119.234.57.159"
}

variable "vpc_name_ingress" {
    type = string
    default = "vpc_ingress"
}

variable "vpc_cidrs_ingress" {
  type = string
  default = "10.10.0.0/16"
}

variable "vpc_name_commmon" {
    type = string
    default = "vpc_common"
}

variable "vpc_cidrs_common" {
  type = string
  default = "10.30.0.0/16"
}

variable "vpc_name_prod" {
  type = string
  default = "vpc_prod"
}

variable "vpc_cidrs_prod" {
  type = string
  default = "10.20.0.0/16"
}

variable "vpc_name_jumphost" {
  type = string
  default = "vpc_jumphost"
}

variable "vpc_cidrs_jumphost" {
  type = string
  default = "10.40.0.0/24"
}

variable "vpc_name_nonprod" {
  type = string
  default = "vpc_nonprod"
}

variable "vpc_cidrs_nonprod" {
  type = string
  default = "10.50.0.0/16"
}

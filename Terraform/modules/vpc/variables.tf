variable "vpc_name" {
    type = string
    default = "value"
}

variable "vpc_cidrs" {
  type    = string
  default = "values"
}

variable "availability_zones" {
  type = list(string)
  default = ["ap-southeast-1a","ap-southeast-1b","ap-southeast-1c"]
}

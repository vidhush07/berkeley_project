variable "vpc_id" {
    type = string
}
variable "private_subnet_ids" {
  type = set(string)
}
variable "memorydb_name" {
  default = "dbredis"
}
variable "node_type" {
  default = "db.t4g.small"
}
variable "engine_version" {
  default = "7.1"
}

variable "vpc_cidrs" {
  type = list(string)
}
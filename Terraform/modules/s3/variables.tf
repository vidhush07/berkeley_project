variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "environment" {
  description = "The environment the bucket belongs to."
  type        = string
}

variable "myip" {
    description = "Public ip address of my personal computer"
    type = string
}
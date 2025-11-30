variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "vpc_id" {
  type = string
  description = "Existing VPC id where ALB will be created."
}

variable "public_subnet_ids" {
  type = list(string)
  description = "List of public subnet ids to place the ALB."
}

variable "alb_security_group_name" {
  type    = string
  default = "alb-sg"
}

variable "backend_port" {
  type    = number
  default = 8080
  description = "Port on which the backend (EKS service) listens."
}

variable "eks_service_ips" {
  type = list(string)
  description = "External IP(s) of the EKS Service (list of IPs)."
}

variable "domain_name" {
  type        = string
  description = "Optional - domain name to use for CloudFront (CNAME)."
  default     = ""
}

variable "acm_certificate_arn" {
  type        = string
  description = "ACM Certificate ARN to use on ALB listener (must be in same region as ALB)."
  default = ""
}

variable "hosted_zone_id" {
  type = string
  description = "Route53 hosted zone id if you want to create records (optional). Leave empty to skip."
  default = ""
}

variable "cloudfront_allow_ips" {
  type = list(string)
  description = "Optional list of CIDRs allowed to reach ALB (e.g., CloudFront IPs). If empty, allows 0.0.0.0/0."
  default = []
}

variable "cloudfront_price_class" {
  type    = string
  default = "PriceClass_100"
}

variable "cloudwatch_enable" {
  type = string
  description = "Enable cloudwatch with this variables"
}

variable "cf_acm_us_east_1" {
  type        = string
  description = "ACM cert ARN in us-east-1 for CloudFront custom domain. Required if domain_name is set."
  default     = ""
}
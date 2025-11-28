provider "aws" {
  region = var.aws_region
  # recommended: use profiles or assume role
}

# module "s3_bucket" {
#     source = "./modules/s3"
#     bucket_name = var.bucket_name
#     environment = var.env
#     myip = var.myip
# }

module "vpc_ingress" {
  source = "./modules/vpc"
  vpc_name = var.vpc_name_ingress
  vpc_cidrs = var.vpc_cidrs_ingress
}

module "vpc_common" {
    source = "./modules/vpc"
    vpc_name = var.vpc_name_commmon
    vpc_cidrs = var.vpc_cidrs_common
}

module "vpc_prod" {
    source = "./modules/vpc"
    vpc_name = var.vpc_name_prod
    vpc_cidrs = var.vpc_cidrs_prod
}


module "vpc_jumphost" {
    source = "./modules/vpc"
    vpc_name = var.vpc_name_jumphost
    vpc_cidrs = var.vpc_cidrs_jumphost
}


module "vpc_nonprod" {
    source = "./modules/vpc"
    vpc_name = var.vpc_name_nonprod
    vpc_cidrs = var.vpc_cidrs_nonprod
}

module "subnets_common" {
  source = "./modules/subnet"
  vpc_id = module.vpc_common.vpc_id
  public_cidrs = []
  private_cidrs = ["10.30.0.0/18", "10.30.64.0/18", "10.30.128.0/18"]
  availability_zones = var.availability_zones
  internetgateway_id = ""
}

module "internetgateway_ingress" {
  source = "./modules/internetgateway"
  vpc_id = module.vpc_ingress.vpc_id
}

module "subnets_ingress" {
  source = "./modules/subnet"
  vpc_id = module.vpc_ingress.vpc_id
  public_cidrs = ["10.10.192.0/18"]
  private_cidrs = ["10.10.0.0/18", "10.10.64.0/18", "10.10.128.0/18"]
  availability_zones = var.availability_zones
  internetgateway_id = module.internetgateway_ingress.igw_id
}

module "subnets_prod" {
  source = "./modules/subnet"
  vpc_id = module.vpc_prod.vpc_id
  public_cidrs = []
  private_cidrs = ["10.20.0.0/18", "10.20.64.0/18", "10.20.128.0/18"]
  availability_zones = var.availability_zones
  internetgateway_id = ""
}

module "subnets_jumphost" {
  source = "./modules/subnet"
  vpc_id = module.vpc_jumphost.vpc_id
  public_cidrs = []
  private_cidrs = ["10.40.0.0/25"]
  availability_zones = var.availability_zones
  internetgateway_id = ""
}

resource "aws_vpc_peering_connection" "peering_ingress_prod" {
  peer_vpc_id   = module.vpc_prod.vpc_id
  vpc_id        = module.vpc_ingress.vpc_id
  auto_accept   = true
}

resource "aws_vpc_peering_connection" "peering_ingress_nonprod" {
  peer_vpc_id   = module.vpc_nonprod.vpc_id
  vpc_id        = module.vpc_ingress.vpc_id
    auto_accept   = true
}

resource "aws_vpc_peering_connection" "peering_ingress_common" {
  peer_vpc_id   = module.vpc_common.vpc_id
  vpc_id        = module.vpc_ingress.vpc_id
  auto_accept   = true  
}

resource "aws_vpc_peering_connection" "peering_ingress_jumphost" {
  peer_vpc_id   = module.vpc_jumphost.vpc_id
  vpc_id        = module.vpc_ingress.vpc_id
  auto_accept   = true
}

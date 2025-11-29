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
  vpc_name = "vpc_ingress"
  vpc_cidrs = "10.10.0.0/16"
}

module "vpc_common" {
    source = "./modules/vpc"
    vpc_name = "vpc_common"
    vpc_cidrs =  "10.30.0.0/16"
}

module "vpc_prod" {
    source = "./modules/vpc"
    vpc_name = "vpc_prod"
    vpc_cidrs = "10.20.0.0/16"
}


module "vpc_jumphost" {
    source = "./modules/vpc"
    vpc_name = "vpc_jumphost"
    vpc_cidrs = "10.40.0.0/24"
}


module "vpc_nonprod" {
    source = "./modules/vpc"
    vpc_name = "vpc_nonprod"
    vpc_cidrs = "10.50.0.0/16"
}

module "internetgateway_ingress" {
  source = "./modules/internetgateway"
  vpc_id = module.vpc_ingress.vpc_id
}

module "subnets_public_ingress" {
  source = "./modules/subnet_public"
  vpc_id = module.vpc_ingress.vpc_id
  public_cidrs = ["10.10.192.0/18"]
  availability_zones = var.availability_zones
  internetgateway_id = module.internetgateway_ingress.igw_id
}

module "subnets_private_ingress" {
  source = "./modules/subnet_private"
  vpc_id = module.vpc_ingress.vpc_id
  private_cidrs = ["10.10.0.0/18", "10.10.64.0/18", "10.10.128.0/18"]
  availability_zones = var.availability_zones
}


module "subnets_private_common" {
  source = "./modules/subnet_private"
  vpc_id = module.vpc_common.vpc_id
  private_cidrs = ["10.30.0.0/18", "10.30.64.0/18", "10.30.128.0/18"]
  availability_zones = var.availability_zones
}


module "subnets_private_prod" {
  source = "./modules/subnet_private"
  vpc_id = module.vpc_prod.vpc_id
  private_cidrs = ["10.20.0.0/18", "10.20.64.0/18", "10.20.128.0/18"]
  availability_zones = var.availability_zones
}

module "subnets_private_jumphost" {
  source = "./modules/subnet_private"
  vpc_id = module.vpc_jumphost.vpc_id
  private_cidrs = ["10.40.0.0/25"]
  availability_zones = var.availability_zones
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

output "vpc_common_cidrs" {
  value = module.vpc_common.vpc_cidrs
}

module "ec2_common" {
  source = "./modules/ec2"
  vpc_cidrs = module.vpc_common.vpc_cidrs
  vpc_id = module.vpc_common.vpc_id

  ec2_ami = "ami-0b3eb051c6c7936e9"
  ec2_instancetype = "t2.micro"
  ec2_subnetid = module.subnets_private_common.private_subnet_ids_by_az[0]
  sg_name = "sg_ec2"
}
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

module "subnets_public_common" {
  source = "./modules/subnet_public"
  vpc_id = module.vpc_common.vpc_id
  public_cidrs = ["10.30.192.0/18"]
  availability_zones = ["ap-southeast-1a"]

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

module "peering_common_prod" {
  source = "./modules/peering"
  vpc_id_1 = module.vpc_common.vpc_id
  vpc_id_2 = module.vpc_prod.vpc_id
  route_table_vpc_id_1 = module.vpc_common.vpc_route_table_id
  route_table_vpc_id_2 = module.vpc_prod.vpc_route_table_id
  cidr_block_vpc_id_1 = module.vpc_common.vpc_cidrs
  cidr_block_vpc_id_2 = module.vpc_prod.vpc_cidrs
}

module "peering_ingress_prod" {
  source = "./modules/peering"
  vpc_id_1 = module.vpc_ingress.vpc_id
  vpc_id_2 = module.vpc_prod.vpc_id
  route_table_vpc_id_1 = module.vpc_ingress.vpc_route_table_id
  route_table_vpc_id_2 = module.vpc_prod.vpc_route_table_id
  cidr_block_vpc_id_1 = module.vpc_ingress.vpc_cidrs
  cidr_block_vpc_id_2 = module.vpc_prod.vpc_cidrs
}

output "vpc_common_cidrs" {
  value = module.vpc_common.vpc_cidrs
}

module "nat_gateway_common_ec2" {
  source = "./modules/nat-gateway"
  subnet_public_id = module.subnets_public_common.public_subnet_ids[0]
  subnet_private_id = module.subnets_private_common.private_subnet_ids_by_az[0]
  route_table_private_id = module.vpc_common.vpc_route_table_id
  route_table_public_id = module.subnets_public_common.route_table_vpc_id
  igw_vpc_id = module.subnets_public_common.igw_vpc_id
  vpc_id = module.vpc_common.vpc_id
}

module "ec2_common" {
  source = "./modules/ec2"
  vpc_cidrs = module.vpc_common.vpc_cidrs
  vpc_id = module.vpc_common.vpc_id

  ec2_ami = "ami-0b3eb051c6c7936e9"
  ec2_instancetype = "t2.large"
  ec2_subnetid = module.subnets_private_common.private_subnet_ids_by_az[0]
  sg_name = "sg_ec2"
  private_subnets = [module.subnets_private_common.private_subnet_ids_by_az[0], module.subnets_private_common.private_subnet_ids_by_az[1], module.subnets_private_common.private_subnet_ids_by_az[2]]
  region = var.aws_region
  route_table_ids = [module.vpc_common.vpc_route_table_id]
  user_data = file("${path.module}/userdata/gitlab.sh")
}

module "dbredis_prod" {
  source = "./modules/memorydb"
  memorydb_name = "dbredisprod"
  private_subnet_ids = [module.subnets_private_prod.private_subnet_ids_by_az[0], module.subnets_private_prod.private_subnet_ids_by_az[1], module.subnets_private_prod.private_subnet_ids_by_az[2]]
  node_type = "db.t4g.small"
  engine_version = "7.1"
  vpc_cidrs = [module.vpc_prod.vpc_cidrs]
  vpc_id = module.vpc_prod.vpc_id
}

module "eks_prod" {
  source = "./modules/eks"
  cluster_name = "eksprod"
  region = var.aws_region
  vpc_id = module.vpc_prod.vpc_id
  private_subnet_azs = [module.subnets_private_prod.private_subnet_ids_by_az[0], module.subnets_private_prod.private_subnet_ids_by_az[1], module.subnets_private_prod.private_subnet_ids_by_az[2]]
  private_subnets = [module.subnets_private_prod.private_subnet_ids_by_az[0], module.subnets_private_prod.private_subnet_ids_by_az[1], module.subnets_private_prod.private_subnet_ids_by_az[2]]
  vpc_cidrs = [module.vpc_prod.vpc_cidrs]
  sg_name = "sg_eksprod"
  route_table_ids = [module.vpc_prod.vpc_route_table_id]
}

module "frontend" {
  source = "./modules/frontend"
  aws_region = var.aws_region
  vpc_id = module.vpc_ingress.vpc_id
  public_subnet_ids = module.subnets_public_ingress.public_subnet_ids
  alb_security_group_name = "sgfrontendalb"
  backend_port = 8080
  eks_service_ips = ["10.10.192.50"]
  cloudwatch_enable = false
  cloudfront_price_class = "PriceClass_100"
}

resource "aws_ecr_repository" "ecr_repo" {
  name = "berkeley_project"

  image_scanning_configuration {
    scan_on_push = false
  }
}

provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket          = "devops-qr-project-terraform"
    key             = "Terraform/terraform.tfstate"
    region          = "ap-south-1"
    #dynamodb_table = "Terraform-state-lock"
  }
}

module "vpc" {
  source = "./modules/vpc"

  region              = var.region
  environment         = var.environment
  Name                = var.Name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_az    = var.public_subnet_az
  private_subnet_az   = var.private_subnet_az
  tags                = var.tags
}

module "eks" {
  source = "./modules/eks"

  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  cluster_name        = var.cluster_name
  cluster_version     = var.cluster_version
  subnet_ids          = [module.vpc.public_subnet_id, module.vpc.private_subnet_id]
  node_instance_type  = var.node_instance_type
  desired_size        = var.desired_size
  min_size            = var.min_size
  max_size            = var.max_size
  tags                = var.tags
}

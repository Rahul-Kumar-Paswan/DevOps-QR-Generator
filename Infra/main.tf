provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "devops-qr-project-terraform"
    key    = "Terraform/terraform.tfstate"
    region = "ap-south-1"
    # dynamodb_table = "Terraform-state-lock" # Optional: Enable state locking
  }
}

module "vpc" {
  source = "./modules/vpc"

  environment          = var.environment
  Name                 = var.Name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = [var.public_subnet_cidr_1, var.public_subnet_cidr_2]
  public_subnet_azs    = [var.public_subnet_az_1, var.public_subnet_az_2]
  tags                 = var.tags
}

module "eks" {
  source = "./modules/eks"

  environment         = var.environment
  cluster_name        = var.cluster_name
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnet_ids
  node_instance_type  = var.node_instance_type
  desired_size        = var.desired_size
  min_size            = var.min_size
  max_size            = var.max_size
  tags                = var.tags
}

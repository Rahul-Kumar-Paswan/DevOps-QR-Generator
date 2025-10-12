# AWS region
variable "region" {}

# Environment / project name
variable "environment" {}
variable "Name" {}
variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
}


# VPC variables
variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "public_subnet_az" {}
variable "private_subnet_az" {}

# EKS variables
variable "cluster_name" {}
variable "cluster_version" {}
variable "node_instance_type" {}
variable "desired_size" {}
variable "min_size" {}
variable "max_size" {}

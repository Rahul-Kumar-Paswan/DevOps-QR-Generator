variable "region" {}
variable "environment" {}
variable "Name" {}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}

# VPC variables
variable "vpc_cidr" {}

variable "public_subnet_cidr_1" {}
variable "public_subnet_cidr_2" {}
variable "public_subnet_az_1" {}
variable "public_subnet_az_2" {}

# EKS variables
variable "cluster_name" {}
variable "node_instance_type" {}
variable "desired_size" {}
variable "min_size" {}
variable "max_size" {}

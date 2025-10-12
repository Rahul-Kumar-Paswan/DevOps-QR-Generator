region = "ap-south-1"
tags = {
  Project     = "QR-Generator"
  Environment = "dev"
  Owner       = "rahul"
  ManagedBy   = "Terraform"
}
environment = "dev"
Name = "QR-Generator"

# VPC
vpc_cidr = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
public_subnet_az = "ap-south-1a"
private_subnet_az = "ap-south-1b"

# EKS
cluster_name = "devops-qr-cluster"
cluster_version = "1.28"
node_instance_type = "t3.small"
desired_size = 2
min_size = 1
max_size = 3

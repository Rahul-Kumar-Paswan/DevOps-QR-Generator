region      = "ap-south-1"
environment = "dev"
Name        = "devops-qr-generator"

# VPC
vpc_cidr              = "10.0.0.0/16"
public_subnet_cidr_1  = "10.0.1.0/24"
public_subnet_cidr_2  = "10.0.2.0/24"
public_subnet_az_1    = "ap-south-1a"
public_subnet_az_2    = "ap-south-1b"

# EKS
cluster_name        = "devops-qr-cluster"
node_instance_type  = "t3.small"
desired_size        = 2
min_size            = 1
max_size            = 3

# Optional tags
tags = {
  Project     = "QRGenerator"
  Environment = "Dev"
}

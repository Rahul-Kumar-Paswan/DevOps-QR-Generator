variable "region" {}
variable "environment" {}
variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

variable "Name" {}
variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "public_subnet_az" {}
variable "private_subnet_az" {}

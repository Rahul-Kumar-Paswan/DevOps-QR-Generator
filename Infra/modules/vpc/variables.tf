variable "environment" {}
variable "Name" {}
variable "tags" {
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {}
variable "public_subnet_cidrs" {
  type = list(string)
}
variable "public_subnet_azs" {
  type = list(string)
}

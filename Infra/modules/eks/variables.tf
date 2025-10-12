variable "environment" {}
variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

variable "cluster_name" {}
variable "cluster_version" {}

variable "subnet_ids" {
  type = list(string)
}

variable "node_instance_type" {}
variable "desired_size" {}
variable "min_size" {}
variable "max_size" {}

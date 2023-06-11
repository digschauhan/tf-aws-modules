variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "vpc_name" {
  type    = string
  default = "eks-cluster-vpc"
}

variable "eks_cluster_name" {
  type    = string
  default = "eks-dev-cluster"
}
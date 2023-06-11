variable "cluster_name" {
  type    = string
  default = "my-eks-cluster"
}

variable "kubernetes_version" {
  type    = string
  default = "1.27"
}

variable "vpc_id" {
  type     = string
  nullable = false
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "common_tags" {
  type = map(string)
  default = {
    "ManagedBy" = "terraform"
  }
}

# Worker node variables
variable "workers_ami_id" {
  type = string
  #default = "ami-0f30ede0d49b940f6"
  #default = "${data.aws_ssm_parameter.eks_ami_id.value}"
  default = ""
}

variable "workers_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "workers_storage_size" {
  type    = number
  default = 10
}

variable "workers_max" {
  type    = number
  default = 5
}

variable "workers_min" {
  type    = number
  default = 1
}

variable "workers_desired" {
  type    = number
  default = 1
}
variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/18"
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["192.168.0.0/20", "192.168.16.0/20", "192.168.32.0/20"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["192.168.48.0/22", "192.168.52.0/22", "192.168.56.0/22"]
}

variable "vpc_name" {
  type    = string
  default = "cluster-vpc"
}

variable "common_tags" {
  type = map(string)
  default = {
    "ManagedBy" = "terraform"
  }
}
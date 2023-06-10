
module "vpc" {
  source = "../modules/vpc"

  vpc_name = "cluster_vpc"
}
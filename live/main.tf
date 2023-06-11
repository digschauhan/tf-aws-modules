
module "vpc" {
  source = "../modules/vpc"

  vpc_name = "cluster_vpc"
}

module "eks" {
  source = "../modules/eks"

  cluster_name          = "dev-cluster"
  vpc_id                = module.vpc.cluster_vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  public_subnet_ids     = module.vpc.public_subnet_ids
  workers_instance_type = "t2.micro"
}
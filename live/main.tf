
module "vpc" {
  source = "../modules/vpc"

  vpc_name         = var.vpc_name
  eks_cluster_name = var.eks_cluster_name
}

module "eks" {
  source = "../modules/eks"

  cluster_name           = var.eks_cluster_name
  vpc_id                 = module.vpc.cluster_vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  public_subnet_ids      = module.vpc.public_subnet_ids
  workers_instance_types = ["t2.micro"]
}
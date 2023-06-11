output "cluster_vpc_id" {
  value = module.vpc.cluster_vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "internet_gateway" {
  value = module.vpc.internet_gateway
}

output "nat_gateway" {
  value = module.vpc.nat_gateway
}

output "eks_security_group" {
  value = module.eks.eks_security_group
}

output "eks_ca" {
  value = module.eks.eks_ca
}

output "eks_endpoint" {
  value = module.eks.eks_endpoint
}

output "eks_sg" {
  value = module.eks.eks_sg
}

output "eks_cluster_role_arn" {
  value = module.eks.eks_cluster_role_arn
}

output "workers_role_arn" {
  value = module.eks.workers_role_arn
}

output "workers_sg" {
  value = module.eks.workers_sg
}
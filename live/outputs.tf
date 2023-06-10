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
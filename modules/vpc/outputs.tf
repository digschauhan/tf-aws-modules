output "cluster_vpc_id" {
  value = aws_vpc.cluster_vpc.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets.*.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets.*.id
}

output "internet_gateway" {
  value = aws_internet_gateway.vpc_ig.id
}

output "nat_gateway" {
  value = aws_nat_gateway.cluster_nat.*.id
}

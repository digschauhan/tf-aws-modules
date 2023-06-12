data "aws_availability_zones" "azs" {
  state = "available"

}

# Create Cluster VPC
resource "aws_vpc" "cluster_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = merge(
    var.common_tags,
    { Name = "${var.vpc_name}" },
  )

  lifecycle {
    ignore_changes = [tags]
  }
}

# Private and Public subnets
resource "aws_subnet" "private_subnets" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.cluster_vpc.id

  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.azs.names[count.index]

  tags = merge(
    var.common_tags,
    { Name = "${var.vpc_name}-private-subnet-${data.aws_availability_zones.azs.names[count.index]}" },
    { "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared" },
  )

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_subnet" "public_subnets" {
  count  = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.cluster_vpc.id

  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.azs.names[count.index]

  tags = merge(
    var.common_tags,
    { Name = "${var.vpc_name}-public-subnet-${data.aws_availability_zones.azs.names[count.index]}" },
    { "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared" },
  )

  lifecycle {
    ignore_changes = [tags]
  }
}

# Internet Gateway for cluster VPC
resource "aws_internet_gateway" "vpc_ig" {
  vpc_id = aws_vpc.cluster_vpc.id
  tags = merge(
    var.common_tags,
    { Name = "${var.vpc_name}-ig" },
  )
}

# Elastic IPs for NAT gateway
resource "aws_eip" "eip" {
  count = length(var.public_subnet_cidrs)

  tags = merge(
    var.common_tags,
    { Name = "${aws_subnet.public_subnets[count.index].id}-eip" },
  )
}

# NAT Gateway, connect with public subnet
resource "aws_nat_gateway" "cluster_nat" {
  count         = length(var.public_subnet_cidrs)
  subnet_id     = aws_subnet.public_subnets[count.index].id
  allocation_id = aws_eip.eip[count.index].id

  tags = merge(
    var.common_tags,
    { Name = "${aws_subnet.public_subnets[count.index].id}-nat" },
  )

  depends_on = [aws_internet_gateway.vpc_ig]
}

# Route tables - private subnets
resource "aws_route_table" "vpc_private_route_tables" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.cluster_vpc.id
}

resource "aws_route" "vpc_private_routes" {
  count                  = length(var.private_subnet_cidrs)
  route_table_id         = element(aws_route_table.vpc_private_route_tables.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.cluster_nat.*.id, count.index)
  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "vpc_private_route_association" {
  count          = length(var.private_subnet_cidrs)
  route_table_id = element(aws_route_table.vpc_private_route_tables.*.id, count.index)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
}


# Route tables - public subnets
resource "aws_route_table" "vpc_public_route_table" {
  vpc_id = aws_vpc.cluster_vpc.id
}

resource "aws_route" "vpc_public_route" {
  route_table_id         = aws_route_table.vpc_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_ig.id
  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "vpc_public_rt_association" {
  count          = length(var.public_subnet_cidrs)
  route_table_id = aws_route_table.vpc_public_route_table.id
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
}
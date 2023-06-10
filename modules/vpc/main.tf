data "aws_availability_zones" "azs" {

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
  availability_zone = data.aws_availability_zones.azs.all_availability_zones[count.index]

  tags = merge(
    var.common_tags,
    { Name = "${var.vpc_name}-private-subnet-${data.aws_availability_zones.azs.all_availability_zones[count.index]}" },
  )

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_subnet" "public_subnets" {
  count  = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.cluster_vpc.id

  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.azs.all_availability_zones[count.index]

  tags = merge(
    var.common_tags,
    { Name = "${var.vpc_name}-public-subnet-${data.aws_availability_zones.azs.all_availability_zones[count.index]}" },
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

# NAT Gateway, connect with public subnet
resource "aws_nat_gateway" "cluster_nat" {
  count     = length(var.public_subnet_cidrs)
  subnet_id = aws_subnet.public_subnets[count.index].id

  tags = merge(
    var.common_tags,
    { Name = "${aws_subnet.public_subnets[count.index].id}-nat" },
  )

  depends_on = [aws_internet_gateway.vpc_ig]
}
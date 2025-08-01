resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name      = "${var.vpc_name}"
    ManagedBy = "Terraform"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name      = "${var.vpc_name}-igw"
    ManagedBy = "Terraform"
  }
}

resource "aws_eip" "ngw" {
  domain = "vpc"

  tags = {
    Name      = "${var.vpc_name}-nat-eip"
    ManagedBy = "Terraform"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = values(aws_subnet.public)[0].id

  tags = {
    Name      = "${var.vpc_name}-ngw"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "public" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name      = "${var.vpc_name}-public-subnet-${each.key}"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name      = "${var.vpc_name}-private-subnet-${each.key}"
    ManagedBy = "Terraform"
  }
}

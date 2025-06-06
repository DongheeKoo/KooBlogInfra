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

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet.cidr_block
  availability_zone = var.public_subnet.availability_zone

  tags = {
    Name      = "${var.vpc_name}-public-subnet"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet.cidr_block
  availability_zone = var.private_subnet.availability_zone

  tags = {
    Name      = "${var.vpc_name}-private-subnet"
    ManagedBy = "Terraform"
  }
}

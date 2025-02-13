resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "Public Route Table"
  }

  depends_on = [aws_internet_gateway.gateway]
}

resource "aws_subnet" "public" {
  count                           = length(var.public_subnets_cidr)
  vpc_id                          = var.vpc_id
  cidr_block                      = var.public_subnets_cidr[count.index]
  availability_zone               = var.availability_zones[count.index]
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block                 = cidrsubnet(var.ipv6_cidr_block, 8, count.index)

  tags = {
    Name = "Public-${count.index}"
  }

}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "Private-${count.index}"
  }
}


resource "aws_route_table_association" "public" {
  count = length(var.public_subnets_cidr)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id

  depends_on = [aws_route_table.public, aws_subnet.public]

}

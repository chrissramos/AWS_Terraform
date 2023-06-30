data "aws_availability_zones" "available" {
  state = "available"
}

#VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "VPC-PROJECT-RANDALL"
  }
}

### Public Subnets
resource "aws_subnet" "public" {
  count      = length(data.aws_availability_zones.available.zone_ids)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags ={
    Name = "Public Subnet ${count.index}"
  }
}
### Private Subnets
resource "aws_subnet" "private" {
  count      = length(data.aws_availability_zones.available.zone_ids)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index + length(aws_subnet.public))
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "Private Subnet ${count.index}"
  }
}


## Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "GW Randall"
  }
}

#elastic ip
resource "aws_eip" "nat" {
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "Nateway-Randall"
  }

  depends_on = [aws_internet_gateway.gw]
}

## Route Table
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "RT-PUBLIC-RANDALL"
  }
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "RT-PRIVATE-RANDALL"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(data.aws_availability_zones.available.zone_ids)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "private" {
  count          = length(data.aws_availability_zones.available.zone_ids)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.rt_private.id
}

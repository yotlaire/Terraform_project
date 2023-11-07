## Route Table && Nat Gateway

# Route Table for Public Subnet
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}
# Association between Public Subnet and Public Route Table
resource "aws_route_table_association" "public-assoc-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public-rt.id
}
resource "aws_route_table_association" "public-assoc-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public-rt.id
}
# Route Table for Private Subnet via nat-gw-1
resource "aws_route_table" "private-rt-1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw-1.id
  }

  tags = {
    Name = "Private Route Table-1"
  }
}
# Route Table for Private Subnet via nat-gw-2
resource "aws_route_table" "private-rt-2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw-2.id
  }

  tags = {
    Name = "Private Route Table-2"
  }
}
# Association between Private Subnet and Private Route Table
resource "aws_route_table_association" "private-assoc-1" {
  subnet_id      = aws_subnet.private-1.id
  route_table_id = aws_route_table.private-rt-1.id
}

resource "aws_route_table_association" "private-assoc-2" {
  subnet_id      = aws_subnet.private-2.id
  route_table_id = aws_route_table.private-rt-2.id
}
# Elastic IP for NAT Gateway public-1
resource "aws_eip" "nat_eip-1" {
  domain        = "vpc"
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "NAT Gateway EIP public-1"
  }
}

# NAT Gateway for public-1
resource "aws_nat_gateway" "nat-gw-1" {
  allocation_id = aws_eip.nat_eip-1.id
  subnet_id     = aws_subnet.public-1.id

  tags = {
    Name = "NAT Gateway Public-1"
  }
}

# Elastic IP for NAT Gateway public-2
resource "aws_eip" "nat_eip-2" {
  domain        = "vpc"
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "NAT Gateway EIP public-2"
  }
}

# NAT Gateway for public-2
resource "aws_nat_gateway" "nat-gw-2" {
  allocation_id = aws_eip.nat_eip-2.id
  subnet_id     = aws_subnet.public-2.id

  tags = {
    Name = "NAT Gateway Public-2"
  }
}
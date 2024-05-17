#create a NAT gateway. It is used in private subnets to allow services to connect to the internet. 
#For NAT, we need to allocate public IP address first. 
#Then we can use it in the aws_nat_gateway resource. 
#You need to place it in the public subnet. 
#That subnet must have an internet gateway as a default route.

resource "aws_eip" "nat_az1_eip" {

  tags = {
    Name = "eip1"
  }
}

resource "aws_nat_gateway" "nat_az1" {
  allocation_id = aws_eip.nat_az1_eip.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags = {
    Name = "nat-az1"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat_az2_eip" {

  tags = {
    Name = "eip2"
  }
}

resource "aws_nat_gateway" "nat_az2" {
  allocation_id = aws_eip.nat_az2_eip.id
  subnet_id     = aws_subnet.public_subnet_az2.id

  tags = {
    Name = "nat-az2"
  }

  depends_on = [aws_internet_gateway.igw]
}



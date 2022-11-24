/*
 * Code to make the routes for public subnets to use the internet gateway
 */

resource "aws_route_table" "internet_route_table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name       = "internet-route-table"
    Env        = "production"
  }
}

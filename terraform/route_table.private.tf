/*
 * Code to make the routes for private subnets to use the NAT gateway
 */

resource "aws_route_table" "nat_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gateway.*.id, count.index)
  }

  tags = {
    Name       = "internet-route-table"
    Env        = "production"
  }
}

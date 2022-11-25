/*
 * Code to make the routes for private subnets to use the NAT gateway
 */

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name       = "internet-route-table"
    Env        = "production"
  }
}

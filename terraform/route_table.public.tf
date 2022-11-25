/*
 * Code to make the routes for public subnets to use the internet gateway
 */

resource "aws_route_table" "internet_route_table" {
  vpc_id       = aws_vpc.vpc.id
  tags = {
    Name       = "internet-route-table"
    Env        = "production"
  }
}

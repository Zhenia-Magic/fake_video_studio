/*
 * Code to make the routes for private subnets to use the NAT gateway
 */

resource "aws_route_table_association" "private_route" {
  count          = length(var.aws_zones)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.nat_route_table.id
}

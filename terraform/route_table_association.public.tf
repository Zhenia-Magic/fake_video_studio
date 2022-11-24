/*
 * Code to make the routes for public subnets to use the internet gateway
 */

resource "aws_route_table_association" "public_route" {
  count          = length(var.aws_zones)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.internet_route_table.id
}

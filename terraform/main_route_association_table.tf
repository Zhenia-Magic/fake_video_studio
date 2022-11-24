resource "aws_main_route_table_association" "default" {
  route_table_id = aws_route_table.internet_route_table.id
  vpc_id         = aws_vpc.vpc.id
}

resource "aws_eip" "gateway" {
  count      = length(var.aws_zones)
  vpc        = true
  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.aws_zones)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  allocation_id = element(aws_eip.gateway.*.id, count.index)
  depends_on    = [aws_internet_gateway.internet_gateway]
}

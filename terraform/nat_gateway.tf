/*
 * Code to create Elastic IP and NAT Gateway
 */

resource "aws_eip" "gateway" {
  vpc        = true
  associate_with_private_ip = "10.0.0.5"
  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.public_subnet[0].id
  allocation_id = aws_eip.gateway.id
  depends_on    = [aws_eip.gateway]
}

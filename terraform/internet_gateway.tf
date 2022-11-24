/*
 * Code to create internet gateway for the VPC
 */

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "internet-gateway"
    Env = "production"
  }
}

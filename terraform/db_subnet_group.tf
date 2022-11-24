/*
 * Code to create DB Subnet Group for the private subnets
 */

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = aws_subnet.private_subnet.*.id

  tags = {
    Name               = "db-subnet-group"
    Env                = "production"
  }
}

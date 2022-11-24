resource "aws_db_instance" "default" {
  backup_window             = "03:00-04:00"
  ca_cert_identifier        = "rds-ca-2019"
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.name
  engine_version            = "13.4"
  engine                    = "postgres"
  skip_final_snapshot  = true
  identifier                = "production"
  instance_class            = "db.t3.micro"
  maintenance_window        = "sun:08:00-sun:09:00"
  name                      = "fake_video_studio_db"
  parameter_group_name      = "default.postgres13"
  password                  = "test12345"
  username                  = "postgres"
  allocated_storage         = 10
}

/*
 * Code to define outputs
 */

output "aws_zones" {
  value = [var.aws_zones]
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.db_subnet_group.name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.production.name
}

output "ecsServiceRole_arn" {
  value = aws_iam_role.ecs-service-role.arn
}

output "private_subnet_ids" {
  value = [aws_subnet.private_subnet.*.id]
}

output "public_subnet_ids" {
  value = [aws_subnet.public_subnet.*.id]
}

output "vpc_default_sg_id" {
  value = aws_security_group.ecs.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "dbusername" {
  value = aws_db_instance.production.username
}

output "db_endpoint" {
  value = aws_db_instance.production.endpoint
}

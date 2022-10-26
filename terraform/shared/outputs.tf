output "aws_zones" {
  value = [var.aws_zones]
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.db_subnet_group.name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "ecsServiceRole_arn" {
  value = aws_iam_role.ecsServiceRole.arn
}

output "private_subnet_ids" {
  value = [aws_subnet.private_subnet.*.id]
}

output "public_subnet_ids" {
  value = [aws_subnet.public_subnet.*.id]
}

output "vpc_default_sg_id" {
  value = data.aws_security_group.ecs_sg.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "ecr_repository_worker_endpoint" {
  value = aws_ecr_repository.web.repository_url
}

output "dbusername" {
  value = aws_db_instance.db_instance.username
}

output "db_endpoint" {
  value = aws_db_instance.db_instance.endpoint
}

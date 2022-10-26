/*
 * Code to get the most recent ECS-optimized AMI
 */

data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

/*
 * Code to create ECR repository and ECS cluster
 */

resource "aws_ecr_repository" "web" {
  name  = "web"
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-cluster"
}

/*
 * Create ECS IAM Instance Role and Policy
 * Randomize the names of roles to prevent collisions
 */

resource "random_id" "code" {
  byte_length = 4
}

data "aws_iam_policy_document" "ecsAssumePolicyDocument" {
  version = "2012-10-17"
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    effect = "Allow"
    sid = ""
    principals {
      identifiers = ["ecs.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "ecsInstanceRole" {
  name               = "ecsInstanceRole-${random_id.code.hex}"
  assume_role_policy = data.aws_iam_policy_document.ecsAssumePolicyDocument.json
}

data "aws_iam_policy_document" "ecsInstancePolicyDocument" {
  version = "2012-10-17"
  statement {
    actions = [
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:Submit*",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
      effect = "Allow"
      resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ecsInstanceRolePolicy" {
  name   = "ecsInstanceRolePolicy-${random_id.code.hex}"
  role   = aws_iam_role.ecsInstanceRole.id
  policy = data.aws_iam_policy_document.ecsInstancePolicyDocument.json
}

data "aws_acm_certificate" "sslcert" {
  domain = "*.evgeniia-cloud-tutorial.site"
}

/*
 * Code to create ECS IAM Service Role and Policy
 */

resource "aws_iam_role" "ecsServiceRole" {
  name               = "ecsServiceRole-${random_id.code.hex}"
  assume_role_policy = data.aws_iam_policy_document.ecsAssumePolicyDocument.json
}

data "aws_iam_policy_document" "ecsServicePolicyDocument" {
  version = "2012-10-17"
  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer"
    ]
    effect = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ecsServiceRolePolicy" {
  name   = "ecsServiceRolePolicy-${random_id.code.hex}"
  role   = aws_iam_role.ecsServiceRole.id
  policy = data.aws_iam_policy_document.ecsServicePolicyDocument.json
}

resource "aws_iam_instance_profile" "ecsInstanceProfile" {
  name = "ecsInstanceProfile-${random_id.code.hex}"
  role = aws_iam_role.ecsInstanceRole.name
}

/*
 * Code to initialize VPC
 */

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-cloud-tutorial"
  }
}

/*
 * Code to get security groups for ECS and RDS
 */

data "aws_security_group" "ecs_sg" {
  name   = "default"
  vpc_id = aws_vpc.vpc.id
/*
  *** I was not able to make multiple ingress groups to work, so I will configure it later ***

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  */
}

resource "aws_security_group" "rds_sg" {
  name        = "database_sg"
  vpc_id      = aws_vpc.vpc.id

  /*
  ingress {
    protocol        = "tcp"
    from_port       = 5432
    to_port         = 5432
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  */
}

/*
 * Code to create public and private subnets for each availability zone
 */

resource "aws_subnet" "public_subnet" {
  count             = length(var.aws_zones)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.aws_zones, count.index)
  cidr_block        = "10.0.${(count.index + 1) * 10}.0/24"
  tags = {
    Name = "public-${element(var.aws_zones, count.index)}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.aws_zones)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.aws_zones, count.index)
  cidr_block        = "10.0.${(count.index + 1) * 11}.0/24"
  tags = {
    Name = "private-${element(var.aws_zones, count.index)}"
  }
}

/*
 * Code to create internet gateway for the VPC
 */

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

/*
 * Code to create NAT gateway and allocate Elastic IP for it
 */

resource "aws_eip" "gateway_eip" {}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.gateway_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  depends_on    = [aws_internet_gateway.internet_gateway]
}

/*
 * Code to make the routes for private subnets to use the NAT gateway
 */

resource "aws_route_table" "nat_route_table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.nat_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

resource "aws_route_table_association" "private_route" {
  count          = length(var.aws_zones)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.nat_route_table.id
}

/*
 * Code to make the routes for public subnets to use the internet gateway
 */

resource "aws_route_table" "internet_route_table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.internet_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_route" {
  count          = length(var.aws_zones)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.internet_route_table.id
}

/*
 * Code to create DB Subnet Group for the private subnets
 */

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet"
  subnet_ids = aws_subnet.private_subnet.*.id
}

/*
 * Code to generate ECS Cluster from the template file
 */

data "template_file" "user_data_template" {
  template = file("${path.module}/user_data.sh")
  vars = {
    ecs_cluster_name = aws_ecs_cluster.ecs_cluster.name
  }
}

/*
 * Code to create Launch Configuration
 */

resource "aws_launch_configuration" "aws_conf" {
  image_id             = data.aws_ami.ecs_ami.id
  instance_type        = "t2.micro"
  security_groups      = [data.aws_security_group.ecs_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ecsInstanceProfile.id
  root_block_device {
    volume_size = "8"
  }
  user_data = data.template_file.user_data_template.rendered
  lifecycle {
    create_before_destroy = true
  }
}

/*
 * Code to create Auto Scaling Group
 */

resource "aws_autoscaling_group" "asg" {
  name                = "asg-ecs-enviroment"
  vpc_zone_identifier = aws_subnet.private_subnet.*.id
  min_size            = 1
  max_size            = 3
  desired_capacity          = 1
  launch_configuration      = aws_launch_configuration.aws_conf.id
  health_check_type         = "EC2"
  health_check_grace_period = 120
  default_cooldown          = 30
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "db_instance" {
  engine                  = "mariadb"
  allocated_storage       = "8"
  instance_class          = "db.t2.micro"
  name                    = "fakevideostudiodb"
  identifier              = "fakevideostudiodb"
  username                = "admin"
  password                = "test12345"
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [data.aws_security_group.ecs_sg.id]
  skip_final_snapshot     = true
}

resource "aws_security_group" "public_https" {
  name        = "public-https"
  description = "Allow HTTPS traffic from public"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.public_https.id
  cidr_blocks       = ["0.0.0.0/0"]
}

/*
 * Code to create Application Load Balancer
 */

resource "aws_alb" "alb" {
  name            = "alb-myapp"
  internal        = false
  security_groups = [data.aws_security_group.ecs_sg.id, aws_security_group.public_https.id]
  subnets         = flatten([aws_subnet.public_subnet.*.id])
}

/*
 * Code to create target group for Application Load Balancer
 */

resource "aws_alb_target_group" "default" {
  name     = "tg-myapp"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  stickiness {
    type = "lb_cookie"
  }
}

/*
 * Code to create listeners to connect Application Load Balancer to target group
 */

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.sslcert.arn
  default_action {
    target_group_arn = aws_alb_target_group.default.arn
    type             = "forward"
  }
}

/*
 * Code to create task definition
 */

resource "aws_ecs_task_definition" "td" {
  family                = "web"
  container_definitions = <<TASK_DEFINITION
  [
    {
      "name": "web",
      "image": "${aws_ecr_repository.web.repository_url}:latest",
      "essential": true,
      "cpu": 256,
      "memory": 512,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 0
        }
      ]
    }
  ]
  TASK_DEFINITION
  network_mode          = "bridge"
}

/*
 * Code to create ECS Service
 */

resource "aws_ecs_service" "service" {
  name                               = "fake-video-studio"
  cluster                            = aws_ecs_cluster.ecs_cluster.name
  desired_count                      = length(var.aws_zones)
  iam_role                           = aws_iam_role.ecsServiceRole.arn
  deployment_maximum_percent         = "200"
  deployment_minimum_healthy_percent = "50"
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.default.arn
    container_name   = "web"
    container_port   = "80"
  }
  task_definition = "${aws_ecs_task_definition.td.family}:${aws_ecs_task_definition.td.revision}"
}

/*
 * Code to create Cloudflare DNS record
 */

data "cloudflare_zones" "site" {
  filter {
    name = "evgeniia-cloud-tutorial.site"
  }
}

resource "cloudflare_record" "dns" {
  zone_id     = data.cloudflare_zones.site.zones[0].id
  name        = "www"
  value       = aws_alb.alb.dns_name
  type        = "CNAME"
  proxied     = true
}

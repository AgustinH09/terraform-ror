locals {
  config = jsondecode(file("${path.module}/config.json"))

  total_public_instances = sum([
    for instance in local.config.web_service.instances :
    instance.instance_count if instance.public
  ])
}

data "aws_region" "current" {

}

module "vpc" {
  source     = "../modules/vpc"

  cidr_block = local.config.vpc.cidr_block
  vpc_tags = {
    Name = "Ruby-Template-VPC"
  }
}

module "subnets" {
  source               = "../modules/subnets"

  vpc_id               = module.vpc.vpc_id
  ipv6_cidr_block      = module.vpc.ipv6_cidr_block
  public_subnets_cidr  = [for subnet in local.config.vpc.subnets.public : subnet.cidr_block]
  private_subnets_cidr = [for subnet in local.config.vpc.subnets.private : subnet.cidr_block]
  availability_zones   = [for subnet in local.config.vpc.subnets.public : subnet.availability_zone]
}

module "alb" {
  source            = "../modules/alb"
  alb_name          = "ruby-template-alb"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.subnets.public_subnet_ids
  listener_port     = 80
  target_group_port = 80
}

module "ecr_repository" {
  source = "../modules/ecr"

  repository_name = "ruby-template-ecr"
  image_tag_mutability = "MUTABLE"
  force_delete = true
  scan_on_push = true

  tags = {
    Environment = "production"
    Project = "ruby-template"
  }

  lifecycle_policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 2,
      "description": "Keep up to 3 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 3
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

module "rds_security_group" {
  source      = "../modules/sg"

  vpc_id      = module.vpc.vpc_id
  sg_name     = "rds-sg"
  description = "Security group for the RDS instance"

  ingress_rules = [
    {
      description      = "Allow PostgreSQL traffic"
      from_port        = 5432
      to_port          = 5432
      protocol         = "tcp"
      cidr_blocks      = ["10.0.5.0/24"]
      ipv6_cidr_blocks = []
    }
  ]

  depends_on = []

  tags = {
    Environment = "production"
    Service     = "rds"
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = "ruby-template-rds-subnet-group"
  subnet_ids = module.subnets.private_subnet_ids

  tags = {
    Name = "ruby-template-rds-subnet-group"
  }
}

module "rds_database" {
  source = "../modules/rds"

  engine = "postgres"
  engine_version = "17.2"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  storage_type = "gp2"
  db_name = "rubyTemplateDatabase"
  username = "root"
  password = "rootpasswordchangepls"
  port = 5432
  multi_az = false
  publicly_accessible = false
  storage_encrypted = true
  vpc_security_group_ids  = [module.rds_security_group.id]
  db_subnet_group_name    = aws_db_subnet_group.rds.name


  backup_retention_period = 1
  backup_window = "07:00-09:00"
  maintenance_window = "Mon:00:00-Mon:03:00"
  deletion_protection = false
  # final_snapshot_identifier = "last-snapshot-${timestamp()}"
  skip_final_snapshot     = true

  tags = {
    Environment = "production"
    Project = "ruby-template"
  }
}

module "ecs_logs" {
  source = "../modules/cloudwatch_logs"

  name              = "/ecs/ruby-template-cluster"
  retention_in_days = 30
  tags = {
    Environment = "production"
    Project     = "ruby-template"
  }
}

module "ecs" {
  source = "../modules/ecs"

  aws_region       = "us-east-1"
  cluster_name     = "ruby-template-cluster"
  service_name     = "ruby-service"
  desired_count    = 2
  task_family      = "ruby-template-task"
  task_cpu         = "256"
  task_memory      = "512"
  container_name   = "service-container"
  container_cpu    = 0
  container_memory = 256
  container_port   = 80
  host_port        = 80

  build_image         = true
  push_image          = true
  dockerfile_path     = "../app"
  image_tag           = "ruby-template-image:latest"
  ecr_repository_url  = module.ecr_repository.repository_url
  image_uri           = ""

  rails_master_key    = file("../app/config/master.key")
  secret_key_base     = var.secret_key_base
  database_url        = "postgres://root:rootpasswordchangepls@${module.rds_database.db_endpoint}:5432/rubyTemplateDatabase"
  log_group_name      = module.ecs_logs.name

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  alb_target_group_arn = module.alb.target_group_arn
}

module "ecs_instance_sg" {
  source      = "../modules/sg"

  vpc_id      = module.vpc.vpc_id
  sg_name     = "ecs-instance-sg"
  description = "Security group for ECS container instances"
  ingress_rules = [
    {
      description      = "Allow all inbound traffic"
      from_port        = 0
      to_port          = 65535
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    }
  ]
  egress_rules = [
    {
      description      = "Allow all outbound traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    }
  ]
}

module "ecs_instances" {
  source           = "../modules/auto_scaling_group"

  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.subnets.public_subnet_ids
  ecs_cluster_name = module.ecs.cluster_name
  desired_capacity = 1
  min_size         = 1
  max_size         = 2
  security_group_id = module.ecs_instance_sg.id

  depends_on = [module.ecs_instance_sg]
}

resource "aws_security_group_rule" "allow_ecs_to_db" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = module.rds_security_group.id        # The DB SG
  source_security_group_id = module.ecs_instance_sg.id  # The ECS tasks’ SG
}


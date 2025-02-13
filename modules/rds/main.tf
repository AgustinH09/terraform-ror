
resource "aws_db_instance" "instance" {
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  db_name                 = var.db_name
  username                = var.username
  password                = var.password
  port                    = var.port
  multi_az                = var.multi_az
  publicly_accessible     = var.publicly_accessible
  storage_encrypted       = var.storage_encrypted
  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name    = var.db_subnet_group_name
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  deletion_protection     = var.deletion_protection

  final_snapshot_identifier = var.final_snapshot_identifier
  skip_final_snapshot       = var.skip_final_snapshot

  tags = var.tags

  lifecycle {
    ignore_changes = [db_subnet_group_name]
  }
}


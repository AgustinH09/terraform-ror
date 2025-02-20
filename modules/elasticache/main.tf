resource "aws_elasticache_replication_group" "redis" {
  description = var.replication_group_description

  replication_group_id       = var.replication_group_id
  engine                     = "redis"
  engine_version             = var.engine_version
  node_type                  = var.node_type
  automatic_failover_enabled = var.automatic_failover_enabled
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  parameter_group_name       = var.parameter_group_name
  port                       = var.port
  subnet_group_name          = var.subnet_group_name
  security_group_ids         = var.security_group_ids
  maintenance_window         = var.maintenance_window
  snapshot_window            = var.snapshot_window
  snapshot_retention_limit   = var.snapshot_retention_limit
  tags                       = var.tags
}


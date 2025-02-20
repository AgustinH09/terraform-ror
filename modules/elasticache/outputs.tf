output "cache_endpoint" {
  description = "The endpoint address for the cache."
  value       = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "replication_group_id" {
  description = "The ID of the Redis replication group."
  value       = aws_elasticache_replication_group.redis.id
}


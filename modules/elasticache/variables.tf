variable "engine_version" {
  description = "The version of the engine to use."
  type        = string
  default     = ""
}

variable "node_type" {
  description = "The compute and memory capacity of the nodes (for example, cache.t3.micro)."
  type        = string
  default     = "cache.t3.micro"
}

variable "port" {
  description = "The port number on which each cache node accepts connections."
  type        = number
  default     = 6379
}

variable "parameter_group_name" {
  description = "The name of the parameter group to associate with the cluster."
  type        = string
  default     = null
}

variable "subnet_group_name" {
  description = "The name of the ElastiCache subnet group to use for the cluster."
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "A list of VPC security group IDs associated with the cluster."
  type        = list(string)
  default     = []
}

variable "maintenance_window" {
  description = "Specifies the weekly time range for maintenance on the cluster."
  type        = string
  default     = "sun:05:00-sun:09:00"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "replication_group_id" {
  description = "The replication group identifier (for Redis)."
  type        = string
  default     = ""
}

variable "replication_group_description" {
  description = "A description for the Redis replication group."
  type        = string
  default     = ""
}

variable "automatic_failover_enabled" {
  description = "Specifies whether automatic failover is enabled (Redis only)."
  type        = bool
  default     = false
}

variable "at_rest_encryption_enabled" {
  description = "Specifies whether encryption at rest is enabled (Redis only)."
  type        = bool
  default     = false
}

variable "transit_encryption_enabled" {
  description = "Specifies whether in-transit encryption is enabled (Redis only)."
  type        = bool
  default     = false
}

variable "number_cache_clusters" {
  description = "The number of cache clusters (nodes) in the Redis replication group."
  type        = number
  default     = 1
}

variable "snapshot_window" {
  description = "The daily time range (in UTC) during which a snapshot is taken (Redis only)."
  type        = string
  default     = null
}

variable "snapshot_retention_limit" {
  description = "The number of days for which ElastiCache retains automatic snapshots (Redis only)."
  type        = number
  default     = 0
}


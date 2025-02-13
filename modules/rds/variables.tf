
variable "engine" {
  description = "The database engine to use (e.g., 'postgres', 'mysql')."
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "The version of the database engine."
  type        = string
  default     = ""
}

variable "instance_class" {
  description = "The compute and memory capacity of the DB instance (e.g., 'db.t3.micro')."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "The allocated storage in GiB."
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "The storage type to be associated with the DB instance (e.g., 'gp2', 'io1')."
  type        = string
  default     = "gp2"
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is provisioned."
  type        = string
  default     = "mydb"
}

variable "username" {
  description = "The username for the master DB user."
  type        = string
}

variable "password" {
  description = "The password for the master DB user."
  type        = string
  sensitive   = true
}

variable "port" {
  description = "The port on which the DB instance accepts connections."
  type        = number
  default     = 5432
}

variable "multi_az" {
  description = "Specifies if the RDS instance is deployed across multiple Availability Zones."
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Specifies whether the DB instance is publicly accessible."
  type        = bool
  default     = false
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance storage is encrypted."
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  description = "A list of VPC security group IDs to associate with the DB instance."
  type        = list(string)
  default     = []
}

variable "db_subnet_group_name" {
  description = "The name of the DB subnet group to use for the DB instance."
  type        = string
  default     = ""
}

variable "backup_retention_period" {
  description = "The number of days to retain automated backups."
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created."
  type        = string
  default     = "07:00-09:00"
}

variable "maintenance_window" {
  description = "The weekly time range (in UTC) during which system maintenance can occur."
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "deletion_protection" {
  description = "Specifies whether the DB instance has deletion protection enabled."
  type        = bool
  default     = false
}

variable "final_snapshot_identifier" {
  description = "The name of the final DB snapshot to be created when the DB instance is deleted (if deletion protection is disabled)."
  type        = string
  default     = "last-snapshot"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the DB instance."
  type        = map(string)
  default     = {}
}


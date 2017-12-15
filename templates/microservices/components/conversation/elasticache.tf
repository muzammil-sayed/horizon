resource "aws_elasticache_parameter_group" "conversation_redis" {
  name        = "gc-${var.jive_service}-redis-${var.env}-param"
  family      = "redis2.8"
  description = "Managed by Horizon"
}

# Terraform can't create Replication Groups, so those will need to be created manually

resource "aws_elasticache_cluster" "conversation_redis" {
  cluster_id           = "${var.conversation_cache_cluster_id}"
  engine               = "redis"
  engine_version       = "2.8.24"
  node_type            = "${var.conversation_cache_instance_type}"
  num_cache_nodes      = "${var.conversation_cache_nodes}"
  parameter_group_name = "${aws_elasticache_parameter_group.conversation_redis.name}"
  port                 = 6379
  subnet_group_name    = "${var.default_elasticache_subnet_group}"
  security_group_ids   = ["${aws_security_group.conversation_redis.id}"]

  tags {
    Name              = "${var.conversation_cache_cluster_id}"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
  }
}

resource "aws_elasticache_parameter_group" "presence_redis" {
  name        = "gc-presence-redis-${var.env}-param"
  family      = "redis2.8"
  description = "Managed by Horizon"
}

# Terraform can't create Replication Groups, so those will need to be created manually

resource "aws_elasticache_cluster" "presence_redis" {
  cluster_id           = "${var.presence_cache_cluster_id}"
  engine               = "redis"
  engine_version       = "2.8.24"
  node_type            = "${var.presence_cache_instance_type}"
  num_cache_nodes      = "${var.presence_cache_nodes}"
  parameter_group_name = "${aws_elasticache_parameter_group.presence_redis.name}"
  port                 = 6379
  subnet_group_name    = "${var.default_elasticache_subnet_group}"
  security_group_ids   = ["${aws_security_group.conversation_redis.id}"]

  tags {
    Name              = "${var.presence_cache_cluster_id}"
    pipeline_phase    = "${var.env}"
    jive_service      = "${var.jive_service}"
  }
}

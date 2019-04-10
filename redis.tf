resource "aws_elasticache_replication_group" "mage-vpc-redis-rg" {
  replication_group_id          = "rep-group-1"
  replication_group_description = "replication group"
  node_type                     = "cache.m3.medium"
  number_cache_clusters         = 2
  parameter_group_name          = "default.redis5.0"
  port                          = 6379
  subnet_group_name				= "${aws_elasticache_subnet_group.mage-vpc-redis-sbgr.name}"
  automatic_failover_enabled    = true
  #availability_zones            = ["us-west-1a", "us-west-1b"]
  availability_zones			= ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}"]
  security_group_ids			= ["${aws_security_group.sg-redis.id}"]
  snapshot_retention_limit	= 5
  snapshot_window		= "00:00-02:30"
  maintenance_window		= "sun:02:31-sun:05:00"
  lifecycle {
    ignore_changes = ["number_cache_clusters"]
  }
  tags {
      Name = "mage-vpc-redis-rg"
      Application = "Magento"
      Environment = "TST"
      TechOwnerEmail = "your_email@your_domain"
  }
}
resource "aws_elasticache_subnet_group" "mage-vpc-redis-sbgr" {
  name       = "mage-vpc-redis-sbgr"
  subnet_ids = ["${aws_subnet.Private-1a.id}", "${aws_subnet.Private-1b.id}"]
}
/*
output "Redis Cluster address" {
    value = "${aws_elasticache_replication_group.mage-vpc-redis-rg.primary_endpoint_address}"
}
*/

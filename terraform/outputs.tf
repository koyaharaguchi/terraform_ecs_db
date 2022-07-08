output "db_domain" {
  description = "The domain of the database."
  value       = aws_eip.db_cluster_instance.public_dns
}
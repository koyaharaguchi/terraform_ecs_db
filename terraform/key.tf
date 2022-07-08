resource "aws_key_pair" "db_instance_key" {
  key_name_prefix = "db-instance-key"
  public_key         = var.public_key
}

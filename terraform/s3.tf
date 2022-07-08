resource "aws_s3_bucket" "db" {
  bucket_prefix = "db"
}

resource "aws_s3_object" "db_env" {
  bucket = aws_s3_bucket.db.id
  source = var.db_env_path
  key    = "db.env"
}
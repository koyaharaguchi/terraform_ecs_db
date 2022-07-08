variable "db_env_path" {
  description = "データベースに設定する環境変数ファイルのパスです。"
  type        = string
}

variable "public_key" {
  description = "SSHに使用する公開鍵です。"
  type        = string
}

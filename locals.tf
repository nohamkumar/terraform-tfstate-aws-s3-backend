locals {
  db_name_env   = "${var.namespace}-${var.environment}-tfstate-lock"
  db_name_noenv = "${var.namespace}-tfstate-lock"

  bucket_name_env   = "${var.namespace}-${var.environment}-tfstate"
  bucket_name_noenv = "${var.namespace}-tfstate"
}

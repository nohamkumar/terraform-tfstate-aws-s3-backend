#---------------------------------------------------------------------------------------------------
# DynamoDB Table for State Locking
#---------------------------------------------------------------------------------------------------

resource "aws_dynamodb_table" "statelock" {
  name           = var.environment == "" ? local.db_name_noenv : local.db_name_env
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    environment = var.environment
    namespace   = var.namespace
  }
}

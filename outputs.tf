output "tfstate_bucket_name" {
  description = "Name of the bucket to store .tfstate"
  value       = aws_s3_bucket.tfstate-bucket.bucket
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table created for .tfstate file lock"
  value       = aws_dynamodb_table.statelock.id
}

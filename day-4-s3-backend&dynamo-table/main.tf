resource "aws_s3_bucket" "raj" {
  bucket = "remote-s3-state-file1"

}

resource "aws_s3_bucket_versioning" "raj" {
  bucket = aws_s3_bucket.raj.id
  versioning_configuration {
    status = "Enabled"
  }
}

#create dynamo table
resource "aws_dynamodb_table" "dynamo-terraform-state-lock" {
  name = "terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

}

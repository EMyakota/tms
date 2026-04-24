resource "aws_s3_bucket" "test-bucket" {
  bucket = "emyakota-lesson-38-demo-bucket"
}

resource "aws_s3_bucket" "tfstates-bucket" {
  bucket = "emyakota-lesson-38-tfstate-bucket"
}

resource "aws_dynamodb_table" "state_lock_table" {
  name         = "terraform_state_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  provider = aws.osb
  bucket   = "osb-${var.environment}-state"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  provider = aws.osb
  bucket   = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  provider     = aws.osb
  name         = "${var.environment}-osb-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

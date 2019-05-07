resource "aws_kms_key" "tf_enc_key" {
  description             = "${var.project} ${var.environment} tfstate encryption key"
  deletion_window_in_days = 30

  tags {
    Name        = "${var.project} ${var.environment} tfstate encryption key"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Terraform   = "True"
  }
}

resource "aws_s3_bucket" "tfstate-storage-s3" {
  bucket = "${var.project}-${var.environment}-tfstate"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.tf_enc_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name        = "${var.project} ${var.environment} S3 Remote Terraform State Store"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Terraform   = "True"
  }
}

# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-tfstate-lock" {
  name           = "${var.project}-${var.environment}-tfstate-lock"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name        = "${var.project} ${var.environment} DynamoDB Terraform State Lock Table"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Terraform   = "True"
  }

  depends_on = ["aws_s3_bucket.tfstate-storage-s3"]
}

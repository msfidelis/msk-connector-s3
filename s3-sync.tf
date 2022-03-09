resource "aws_s3_bucket" "topic_sync" {
  bucket = format("%s-%s-%s-sync", var.project_name, var.topic_sync, data.aws_caller_identity.current.account_id)
}

resource "aws_s3_bucket_acl" "topic_sync" {
    bucket = aws_s3_bucket.topic_sync.id
    acl = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "topic_sync" {
  bucket = aws_s3_bucket.topic_sync.id

  rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id   = aws_kms_key.kms.arn
        sse_algorithm       = "aws:kms"
      }
  }
}
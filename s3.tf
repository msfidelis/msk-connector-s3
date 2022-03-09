resource "aws_s3_bucket" "plugins" {
  bucket = format("%s-plugins-%s", var.project_name, data.aws_caller_identity.current.account_id)
}

resource "aws_s3_object" "s3" {
  bucket = aws_s3_bucket.plugins.id
  key    = "kafka-connect-aws.zip"
  source = "./plugins/confluentinc-kafka-connect-s3-10.0.5.zip"

  etag = filemd5("./plugins/confluentinc-kafka-connect-s3-10.0.5.zip")
}
resource "aws_mskconnect_custom_plugin" "s3" {
  name         = format("%s-s3-connect-%s", var.project_name, time_static.release.unix)
  content_type = "ZIP"
  location {
    s3 {
      bucket_arn = aws_s3_bucket.plugins.arn
      file_key   = aws_s3_object.s3.key
    }
  }
}
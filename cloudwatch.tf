
resource "aws_cloudwatch_log_group" "s3" {
  name = format("%s-s3-connect-%s", var.project_name, time_static.release.unix)
}
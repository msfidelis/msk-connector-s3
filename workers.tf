data "template_file" "worker_configuration" {
  template = file("./plugins/s3.properties")
}

resource "aws_mskconnect_worker_configuration" "s3_topic" {
  name                    = format("%s-s3-connect-%s", var.project_name, time_static.release.unix)
  properties_file_content = data.template_file.worker_configuration.rendered
}
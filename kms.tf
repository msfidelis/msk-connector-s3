resource "aws_kms_key" "kms" {
  description = var.project_name
  enable_key_rotation = true 
}
# resource awscc_kafkaconnect_connector "s3" {
#     connector_name =  format("%s-s3-connect-%s", var.project_name, time_static.release.unix)
#     service_execution_role_arn = aws_iam_role.msk.arn
#     kafka_connect_version   = "2.7.1"
#     kafka_cluster_encryption_in_transit = {
#         encryption_type = "TLS"
#     }
#     kafka_cluster   = {
#         apache_kafka_cluster = {
#             bootstrap_servers = aws_msk_cluster.main.bootstrap_brokers_tls
#             vpc = {
#                 subnets         = var.subnets
#                 security_groups = [
#                     aws_security_group.sg.id
#                 ]
#             }
#         }
#     }
#     capacity = {
#         provisioned_capacity = {
#             worker_count = 1
#             mcu_count    = 2
#         }
#     }
#     kafka_cluster_client_authentication = {
#         authentication_type = "NONE"
#     }
#     plugins = [
#         {
#             custom_plugin = {
#                 custom_plugin_arn   = aws_mskconnect_custom_plugin.s3.arn,
#                 revision            = aws_mskconnect_custom_plugin.s3.latest_revision
#             }
#         }
#     ]
#     connector_configuration = tomap({
#     "connector.class"   =   "io.confluent.connect.s3.sink.S3SinkConnector",
#     "format.class"      =   "io.confluent.connect.s3.format.bytearray.ByteArrayFormat"
#     "s3.part.retries"   =   "3"
#     "tasks.max"         =   "2",
#     "s3.region"         =   "us-east-1",
#     "timezone"          =   "America/Sao_paulo",
#     "topics.dir"        =   "topics"
#     "flush.size"        =   "1000"
#     })
# }
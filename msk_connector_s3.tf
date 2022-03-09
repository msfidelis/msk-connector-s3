# resource "aws_mskconnect_worker_configuration" "s3_topic" {
#   name                    = format("%s-%s-s3-connect-%s", var.project_name, var.topic_sync, random_string.s3.result)
#   properties_file_content = <<EOT
# name=${var.topic_sync}-${random_string.s3.result}
# topics=${var.topic_sync}
# s3.region=${var.region}
# s3.bucket.name=${aws_s3_bucket.plugins.bucket}
# connector.class=io.lenses.streamreactor.connect.aws.s3.sink.S3SinkConnector
# key.converter.schemas.enable=false
# tasks.max=1
# value.converter=org.apache.kafka.connect.storage.StringConverter
# errors.log.enable=true
# key.converter=org.apache.kafka.connect.storage.StringConverter
# EOT
# }

# resource "null_resource" "connector_s3" {
#   triggers = merge({
#     always_run = true
#   })

#   provisioner "local-exec" {
#     when = create
#     interpreter = [
#       "/bin/bash", 
#       "-c"
#     ]
#     command = <<CMD
#     ls -lha -S
#     aws kafkaconnect create-connector --connector-name ${format("%s-%s-s3-connect-%s", var.project_name, var.topic_sync, random_string.s3.result)} \
#     --kafka-cluster ${ aws_msk_cluster.main.id} \
#     --kafka-cluster-client-authentication NONE \
#     --kafka-cluster-encryption-in-transit true \
#     --kafka-connect-version 2.7.1 \
#     --worker-configuration ${aws_mskconnect_worker_configuration.s3_topic.arn} \
#     --plugins aws_mskconnect_custom_plugin.s3.arn \
#     --service-execution-role-arn ${aws_iam_role.msk.arn}
#     --capacity

#     CMD
#   }

#   provisioner "local-exec" {
#     when = destroy
#     interpreter = [
#       "/bin/bash", 
#       "-c"
#     ]
#     command = <<CMD
#     printenv
#     CMD
#   }

# }

# resource "aws_mskconnect_worker_configuration" "s3_topic" {
#   name                    = format("%s-%s-s3-connect-%s", var.project_name, var.topic_sync, random_string.s3.result)
#   properties_file_content = <<EOT
# name=${var.topic_sync}
# connector.class=io.confluent.connect.s3.S3SinkConnector
# tasks.max=1
# topics=${var.topic_sync}

# s3.region=${var.region}
# s3.bucket.name=${aws_s3_bucket.plugins.bucket}
# s3.part.size=5242880
# flush.size=3

# key.converter: org.apache.kafka.connect.json.JsonConverter
# value.converter: org.apache.kafka.connect.json.JsonConverter
# storage.class=io.confluent.connect.s3.storage.S3Storage
# # format.class=io.confluent.connect.s3.format.avro.AvroFormat
# format.class=io.confluent.connect.s3.format.json.JsonFormat
# partitioner.class=io.confluent.connect.storage.partitioner.DefaultPartitioner

# schema.compatibility=NONE
# EOT
# }

# resource "aws_mskconnect_worker_configuration" "s3_topic" {
#   name                    = format("%s-%s-s3-connect-%s", var.project_name, var.topic_sync, random_string.s3.result)
#   properties_file_content = <<EOT
# name=s3-sink
# connector.class: io.confluent.connect.s3.S3SinkConnector
# key.converter: org.apache.kafka.connect.json.JsonConverter
# value.converter: org.apache.kafka.connect.json.JsonConverter
# key.converter.schemas.enable: true
# value.converter.schemas.enable: true
# s3.region: ${var.region}
# format.class: io.confluent.connect.s3.format.json.JsonFormat
# flush.size: 3
# schema.compatibility: NONE
# topics: ${var.topic_sync}
# tasks.max: 2
# partitioner.class: io.confluent.connect.storage.partitioner.DefaultPartitioner
# storage.class: io.confluent.connect.s3.storage.S3Storage
# s3.bucket.name: ${aws_s3_bucket.plugins.bucket}
# schema.compatibility=NONE
# EOT
# }


# resource "awscc_kafkaconnect_connector" "s3" {
#   connector_name = format("%s-%s-s3-connect", var.project_name, var.topic_sync)

#   kafka_connect_version = "2.7.1"

#   kafka_cluster_client_authentication = {
#     authentication_type = "NONE"
#   }

#   service_execution_role_arn = aws_iam_role.msk.arn
#   kafka_cluster_encryption_in_transit = {
#     encryption_type = "TLS"
#   }

#   kafka_cluster   = {
#     apache_kafka_cluster = {
#       bootstrap_servers = aws_msk_cluster.main.bootstrap_brokers_tls
#       vpc = {
#         subnets = var.subnets
#         security_groups = [ aws_security_group.sg.id ]
#       }
#     }
#   }

#   capacity = {
#     provisioned_capacity = {
#       mcu_count     = 2
#       worker_count  = 4
#     }

#     # auto_scaling =  {

#     # }
#   }

#   plugins = [
#     {
#       custom_plugin = {
#         custom_plugin_arn = aws_mskconnect_custom_plugin.s3.arn
#         revision          = aws_mskconnect_custom_plugin.s3.latest_revision
#       }
#     }
#   ]

#   connector_configuration = {
#     "connector.class" : "io.confluent.connect.s3.S3SinkConnector"
#     "key.converter": "org.apache.kafka.connect.json.JsonConverter"
#     "value.converter": "org.apache.kafka.connect.json.JsonConverter"
#     "key.converter.schemas.enable": true
#     "value.converter.schemas.enable": true 
#     "s3.region": "${var.region}"
#     "format.class": "io.confluent.connect.s3.format.json.JsonFormat"
#     "flush.size": 1
#     "schema.compatibility": "NONE"
#     "topics": "${var.topic_sync}"
#     "tasks.max": 2
#     "partitioner.class": "io.confluent.connect.storage.partitioner.DefaultPartitioner"
#     "storage.class": "io.confluent.connect.s3.storage.S3Storage"
#     "s3.bucket.name": "${aws_s3_bucket.plugins.bucket}"
#   }
# }
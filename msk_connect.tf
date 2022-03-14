resource awscc_kafkaconnect_connector "s3" {
    connector_name =  format("%s-s3-connect-%s", var.project_name, time_static.release.unix)
    service_execution_role_arn = aws_iam_role.msk.arn
    kafka_connect_version   = "2.7.1"
    kafka_cluster_encryption_in_transit = {
        encryption_type = "TLS"
    }
    kafka_cluster   = {
        apache_kafka_cluster = {
            bootstrap_servers = aws_msk_cluster.main.bootstrap_brokers_tls
            vpc = {
                subnets         = var.subnets
                security_groups = [
                    aws_security_group.sg.id
                ]
            }
        }
    }
    capacity = {
        provisioned_capacity = {
            worker_count = 1
            mcu_count    = 2
        }
    }
    kafka_cluster_client_authentication = {
        authentication_type = "NONE"
    }
    plugins = [
        {
            custom_plugin = {
                custom_plugin_arn   = aws_mskconnect_custom_plugin.s3.arn,
                revision            = aws_mskconnect_custom_plugin.s3.latest_revision
            }
        }
    ]
    worker_configuration = {
        worker_configuration_arn    = aws_mskconnect_worker_configuration.s3_topic.arn
        revision                    = aws_mskconnect_worker_configuration.s3_topic.latest_revision
    }
    log_delivery         = {
        worker_log_delivery = {
            cloudwatch_logs = {
                enabled     = true
                log_group   = format("%s-s3-connect-%s", var.project_name, time_static.release.unix)
            }
        }
    }
    connector_configuration = tomap({
    "connector.class"               =   "io.confluent.connect.s3.S3SinkConnector",
    "format.class"                  =   "io.confluent.connect.s3.format.bytearray.ByteArrayFormat"
    "s3.part.retries"               =   "3"
    "tasks.max"                     =   "2",
    "timezone"                      =   "America/Sao_Paulo",
    "topics.dir"                    =   "topics",
    "flush.size"                    =   "1000",
    "topics.regex"                  =   "(.*)-sync$",
    "path.format"                   =   "YYYY-MM-dd",
    "s3.region"                     =   "us-east-1",    
    "s3.bucket.name"                =   aws_s3_bucket.topic_sync.bucket,
    "format.bytearray.extension"    =   ".json",   
    "timestamp.extractor"           =   "Record"
    "file.delim"                    =   "+"
    "schema.compatibility"          =   "NONE"
    "s3.compression.type"           =   "gzip"
    "connect.meta.data"             =   "false"
    "store.kafka.keys"              =   "false"
    "s3.retry.backoff.ms"           =   "200"
    "partitioner.class"             =   "io.confluent.connect.storage.partitioner.TimeBasedPartitioner"
    "storage.class"                 ="io.confluent.connect.s3.storage.S3Storage"
    # "s3.ssea.name"      = "aws:kms"
    # "s3.ssea.kms.key.id"    = aws_kms_key.main.key_id,
    })

    depends_on = [
        aws_cloudwatch_log_group.s3
    ]
}
resource "aws_msk_cluster" "main" {
  cluster_name           = var.project_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.broker_count

  broker_node_group_info {
    instance_type   = var.node_type
    ebs_volume_size = var.volume_size
    client_subnets  = var.subnets
    security_groups = [aws_security_group.sg.id]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kms.arn
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }
}

resource "aws_security_group" "sg" {
  name        = var.project_name
  description = var.project_name

  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port        = 9092
    to_port          = 9092
    protocol         = "tcp"
    cidr_blocks      = [ data.aws_vpc.main.cidr_block ]
  }

  ingress {
    from_port        = 9094
    to_port          = 9094
    protocol         = "tcp"
    cidr_blocks      = [ data.aws_vpc.main.cidr_block ]
  }

  ingress {
    from_port        = 2182
    to_port          = 2182
    protocol         = "tcp"
    cidr_blocks      = [ data.aws_vpc.main.cidr_block ]
  }

  ingress {
    from_port        = 2181
    to_port          = 2181
    protocol         = "tcp"
    cidr_blocks      = [ data.aws_vpc.main.cidr_block ]
  }

  ingress {
    from_port        = 8443
    to_port          = 8443
    protocol         = "tcp"
    cidr_blocks      = [ data.aws_vpc.main.cidr_block ]
  }

  ingress {
    from_port        = 8083
    to_port          = 8083
    protocol         = "tcp"
    cidr_blocks      = [ data.aws_vpc.main.cidr_block ]
  }    

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
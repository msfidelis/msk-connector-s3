variable "project_name" {
  default = "msk-connector"
}

variable "kafka_version" {
  default = "2.6.2"
}

variable "node_type" {
    type    = string
    default = "kafka.t3.small"
}

variable "broker_count" {
    type    = number
    default = 3
}

variable "volume_size" {
    type    = number
    default =  100
}

variable "topic_sync" {
    type    = string
    default = "mytopic"
}

variable "region" {
  default = "us-east-1"
}

variable "vpc" {
    default = "vpc-ba8b92c1"
}

variable "subnets" {
  type      = list
  default   = [
      "subnet-29954875",
      "subnet-c832eeaf",
      "subnet-23a9760d"
  ]
}

variable "create_vpc_endpoint" {
  type    = bool 
  default = true
}
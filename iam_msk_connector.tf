data "aws_iam_policy_document" "msk" {

  version = "2012-10-17"

  statement {

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "kafkaconnect.amazonaws.com"
      ]
    }

  }

}

data "aws_iam_policy_document" "msk_policy" {
  version = "2012-10-17"

  statement {

    effect = "Allow"
    actions = [
      "kafka-cluster:Connect",
      "kafka-cluster:DescribeCluster"
    ]

    resources = [
      aws_msk_cluster.main.arn
    ]

  }

  statement {

    effect = "Allow"
    actions = [
      "kafka-cluster:WriteData",
      "kafka-cluster:DescribeTopic"
    ]

    resources = [
      "*"
    ]

  }

  statement {

    effect = "Allow"
    actions = [
      "kafka-cluster:CreateTopic",
      "kafka-cluster:WriteData",
      "kafka-cluster:ReadData",
      "kafka-cluster:DescribeTopic"
    ]

    resources = [
      "*"
    ]

  }


  statement {

    effect = "Allow"
    actions = [
      "kafka-cluster:AlterGroup",
      "kafka-cluster:DescribeGroup"
    ]

    resources = [
      "*"
    ]

  }


  statement {

    effect = "Allow"
    actions = [
      "s3:*"
    ]

    resources = [
      "*"
    ]

  }

  statement {

    effect = "Allow"
    actions = [
      "logs:*"
    ]

    resources = [
      "*"
    ]

  } 


  statement {

    effect = "Allow"
    actions = [
      "kms:*"
    ]

    resources = [
      "*"
    ]

  }     
}

resource "aws_iam_role" "msk" {
  name               = format("%s-connector", var.project_name)
  assume_role_policy = data.aws_iam_policy_document.msk.json
}


resource "aws_iam_policy" "msk" {
    name        = format("%s-policy", var.project_name)
    path        = "/"
    description = var.project_name

    policy = data.aws_iam_policy_document.msk_policy.json
}


resource "aws_iam_policy_attachment" "msk" {
    name       = "cluster_autoscaler"
    roles      = [ 
      aws_iam_role.msk.name
    ]

    policy_arn = aws_iam_policy.msk.arn
}
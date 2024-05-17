terraform {
required_providers {
    aws = {
    source  = "hashicorp/aws"
    version = "~> 4.16"
    }
    }
    required_version = ">= 1.2.0"
}

provider "aws" {
    region  = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
    bucket = "upload-bucket-06070"
    acl = "private"
}

resource "aws_sqs_queue" "queue" {
    name = "upload-queue"
    delay_seconds = 60
    max_message_size = 8192
    message_retention_seconds = 172800
    receive_wait_time_seconds = 15
}


data "aws_iam_policy_document" "aws_iam_policy_doc" {
    statement {
        actions = [ "sqs:SendMessage"]
        effect = "Allow"
        resources = [ aws_sqs_queue.queue.arn ]

        condition {
            test = "ArnEquals"
            variable = "aws:SourceArn"
            values = [ aws_s3_bucket.bucket.arn ]
        }

        principals {
            type = "AWS"
            identifiers = [ "*" ]
        }
    }
}

resource "aws_sqs_queue_policy" "notfiy_policy" {
    policy = data.aws_iam_policy_document.aws_iam_policy_doc.json
    queue_url = aws_sqs_queue.queue.url
}

resource "aws_s3_bucket_notification" "bucket_notif" {
    bucket = aws_s3_bucket.bucket.id
    queue {
        queue_arn = aws_sqs_queue.queue.arn
        events = [ "s3:ObjectCreated:*" ]
    }
}
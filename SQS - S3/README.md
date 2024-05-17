# Terraform AWS S3 to SQS Notification Architecture

This repository contains a Terraform configuration that sets up an AWS architecture where an S3 bucket sends notifications to an SQS queue when new objects are created in the bucket.

## Architecture Overview

The architecture consists of the following components:

1. **AWS S3 Bucket**: A private S3 bucket named `upload-bucket-06070`.
2. **AWS SQS Queue**: An SQS queue named `upload-queue` with specific configurations for delay, message size, retention period, and wait time.
3. **IAM Policy Document**: An IAM policy document that allows the S3 bucket to send messages to the SQS queue.
4. **SQS Queue Policy**: A policy attached to the SQS queue that enforces the IAM policy document.
5. **S3 Bucket Notification**: A notification configuration on the S3 bucket that triggers an event to the SQS queue whenever a new object is created.

## Terraform Configuration

### Providers

```hcl
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
  region = "us-east-1"
}

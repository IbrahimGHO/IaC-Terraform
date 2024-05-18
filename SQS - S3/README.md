# AWS S3 to SQS Notification with Terraform

Welcome to the AWS S3 to SQS Notification IaC library! This file contains Terraform configurations to set up an AWS architecture where an S3 bucket sends notifications to an SQS queue when new objects are created.

## Overview

This IaC library includes:

- **S3 Bucket**: A secure, private bucket for storing objects.
- **SQS Queue**: A queue to receive notifications about new objects in the S3 bucket.
- **IAM Policies**: Permissions to allow the S3 bucket to send messages to the SQS queue.
- **Bucket Notification**: Configuration to trigger an event when a new object is added to the S3 bucket.


## Architecture
! (https://raw.githubusercontent.com/IbrahimGHO/IaC-Library-/main/Assests/S3-SQS.png?token=GHSAT0AAAAAACRKVFVIDA24HQRVW2KS572SZSH6IKA)

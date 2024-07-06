![main pic](https://github.com/arifsadiq/aws-terraform-project/assets/38719031/c66c34bc-a3af-4587-ae03-2ffab1021d62)

# Terraform Project for Setting Up an Infrastructure on AWS

## Prerequisites

1. An active AWS account is required
2. Create an IAM user with Administrtive Access to manage AWS resources. Generate and download the access key ID and secret access key for this user.
3. Download and install Terraform from the official Terraform website.
4. Install the AWS Command Line Interface (CLI)
5. Use a text editor or Integrated Development Environment (IDE) to write and manage your Terraform configuration files. For example: Visual Studio Code
6. Log in to AWS using the command

        aws configure
   
### Step 1: Clone this repository

### Step 2: Execute the following terraform commands

    terraform init

    terraform plan

    terraform apply -auto-approve

## Step-by-Step Guide

#### 1. Create VPC
Define the VPC with a name and an IPv4 CIDR block.

#### 2. Create Subnets
Create 2 subnets within the VPC.

#### 3. Create Internet Gateway
Attach an Internet Gateway to the VPC.

#### 4. Create Route Table
Create a route table for the VPC and add a route.

#### 5. Create Route Table Association
Associate the route table with the subnets.

#### 6. Create Security Group
Create a security group in the VPC.

#### 7. Create Security Group Rules for Ingress and Egress
Define rules for the security group.

#### 8. Create S3 Bucket
Create an S3 bucket.

#### 9. Enable Versioning on Bucket
Enable versioning on the S3 bucket.

#### 10. Create two EC2 Instances
Create 2 ec2 instances

#### 11. Create Load Balancer
Create an Application Load Balancer.

#### 12. Create Target Group
Create a target group for the ALB.

#### 13. Create Target Group Attachment
Attach the EC2 instance to the target group.

#### 14. Create ALB Listener
Create a listener for the ALB.

#### 2. Create Outputs 
Define outputs for your resources. This output will provide the url for verifying load balancer service.

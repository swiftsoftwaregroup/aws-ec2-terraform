terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# AWS config
# leave empty to read the settings from the AWS CLI configuration
provider "aws" {}

# use default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group
resource "aws_security_group" "nginx_server_sg_tf" {
  name        = "nginx-server-sg-tf"
  description = "Allow HTTP to web server"
  vpc_id      = data.aws_vpc.default.id

  # Allow inbound traffic on port 80
  ingress {
    description = "HTTP ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH access
  ingress {
    description = "SSH ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "nginx_server_tf" {
  ami                    = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
  instance_type          = "t2.micro"
  key_name               = "aws-ec2-key"
  vpc_security_group_ids = [aws_security_group.nginx_server_sg_tf.id]

  tags = {
    Name = "nginx-server-tf"
  }
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.nginx_server_tf.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.nginx_server_tf.public_ip
}
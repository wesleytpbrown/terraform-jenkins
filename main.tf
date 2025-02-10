terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" #AWS region you want your resources
}



# EC2 Instance for Jenkins
resource "aws_instance" "jenkins-server" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  key_name               = "dockerkey" # Replace with your key pair
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  user_data              = file("jenkins-ud.sh")


  tags = {
    Name = "terraformjenkins"
  }
}



# Security Group for Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-SG"
  description = "Allow SSH and 8080 traffic"




  # Allow SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change this for security your IP for security
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Jenkins (port 8080)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows all incoming traffic
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# S3 Bucket for Jenkins Artifacts
resource "aws_s3_bucket" "jenkins_artifacts" {
  bucket = "jenkins-terraform-bucket" # Change to a unique name

  tags = {
    Name = "terraform-bucket"
  }
}

#Access control list for your bucket
resource "aws_s3_bucket_acl" "jenkins_artifacts_acl" {
  bucket     = aws_s3_bucket.jenkins_artifacts.id
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
  acl        = "private"
}


resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.jenkins_artifacts.id
  rule {
    object_ownership = "ObjectWriter"
  }
}
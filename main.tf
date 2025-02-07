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



# Get Default VPC
data "aws_vpc" "default" {
  default = true
}

# Get Subnet 
variable "subnet_id" {
  default = "subnet-02f8d8e5cfbbd3677" # Replace with your specific subnet ID
}




# Security Group for Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-terraform-SG"
  description = "Allow SSH and Jenkins traffic"

  # Allow SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change this for security your IP for security
  }

  # Allow Jenkins UI (port 8080)
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
}




# EC2 Instance for Jenkins
resource "aws_instance" "jenkins-server"{
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.medium"
  key_name      = "dockerkey.pem" # Replace with your key pair
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  subnet_id              = var.subnet_id # Specify your subnet
  user_data = file("${path.module}/jekins-user-data.sh") # Here reference your script from eariler


  tags = {
    Name = "terraformjenkins"
  }
}




resource "aws_instance" "jenkins_server" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.medium"
  

  


  
  tags = {
    Name = "Jenkins-Server"
  }
}


# Output the Public IP of the EC2 instance
output "jenkins_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}

terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }
    required_version = ">=1.2.0"
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
    key_name   = "deployer-key"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "app_sg" {
    name        = "app_sg"
    description = "Allow SSH and HTTP traffic"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
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

resource "aws_instance" "test-instance" {
    ami = "ami-04b4f1a9cf54c11d0"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.app_sg.id]
    key_name = aws_key_pair.deployer.key_name

    tags = {
        Name = "practiceinstance"
    }
}


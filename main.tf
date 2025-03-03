# Configure the AWS provider with the Academy profile and region
provider "aws" {
  region = "us-east-1"          # Region specified as us-east-1
  profile = "academy"           # Use the AWS Academy profile from ~/.aws/credentials
}

# SSH key pair for access to the instance
resource "aws_key_pair" "deployer_key" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create a security group
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Access from anywhere (restrict in production)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # Accept all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

# Create an EC2 instance
resource "aws_instance" "docker_server" {
  ami           = "ami-04b4f1a9cf54c11d0" # AMI for us-east-1 (verify availability in Academy Lab)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer_key.key_name
  security_groups = [aws_security_group.allow_ssh.name]

  # Script to install Docker
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ubuntu
              EOF

  tags = {
    Name = "DockerServerInstance"
  }
}

# Show the public IP of the instance
output "instance_public_ip" {
  value       = aws_instance.docker_server.public_ip
  description = "Public IP of the EC2 instance"
}
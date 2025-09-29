provider "aws" {
  region = "us-east-1"
}

# --- ECR repository ---
resource "aws_ecr_repository" "hello_repo" {
  name = "hello-world-app"
}

# --- Security Group ---
resource "aws_security_group" "hello_sg" {
  name   = "hello-sg"
  vpc_id = "vpc-xxxxxx" # replace with your VPC

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

# --- IAM Role for EC2 to access ECR ---
resource "aws_iam_role" "ec2_role" {
  name = "ec2-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ecr" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# --- EC2 instance ---
resource "aws_instance" "hello_ec2" {
  ami           = "ami-08c40ec9ead489470" # Amazon Linux 2
  instance_type = "t2.micro"
  subnet_id     = "subnet-xxxxxx"         # replace with your subnet
  vpc_security_group_ids = [aws_security_group.hello_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) ${aws_ecr_repository.hello_repo.repository_url}
              docker run -d -p 8080:8080 ${aws_ecr_repository.hello_repo.repository_url}:latest
              EOF

  tags = {
    Name = "hello-world-ec2"
  }
}

output "ec2_public_ip" {
  value = aws_instance.hello_ec2.public_ip
}


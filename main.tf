terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.86.0"
    }
  }
}

# Data source to find the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create a VPC
data "aws_vpc" "simret-vpc" {
  filter {
    name   = "vpc-id"
    values = ["vpc-09ff3f1f44ab93d60"]
  }
}
data "aws_subnet" "simret-subnet" {
  filter {
    name   = "subnet-id"
    values = ["subnet-04905723d888d2bf7"]
  } # Use the VPC ID from the VPC data block

}

  


# Create a security group in the created VPC
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS and SSH inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.simret-vpc.id

  tags = {
    Name = "allow_tls"
  }
}

# Ingress rule to allow TLS traffic (port 443)
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = data.aws_vpc.simret-vpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# Ingress rule to allow SSH traffic (port 22)
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = data.aws_vpc.simret-vpc.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Create EC2 instance and attach the security group
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id              = data.aws_subnet.simret-subnet.id

  # Attach the security group to the EC2 instance using its ID
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = "var.instance_tags"

  }
  key_name= var.key_name

  # Ensure the EC2 instance is created after the security group is created

  
  user_data = "${file("userdata.sh")}"
}

# ------------------------------------------------------------------
# main.tf
#
# This file defines the core infrastructure resources.
# ------------------------------------------------------------------

# Configure the AWS provider, specifying the region to use.
# It uses the variable defined in variables.tf and the named profile "demoaws".
provider "aws" {
  region  = var.aws_region
  profile = "demoaws"
}

# Define the main VPC (Virtual Private Cloud).
# A VPC is a logically isolated section of the AWS Cloud.
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  # Enable DNS hostnames so we can resolve public DNS names for EC2 instances.
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Create an Internet Gateway (IGW).
# An IGW allows communication between the VPC and the internet.
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Create a public subnet.
# A subnet is a range of IP addresses in your VPC. This one is public
# because its traffic will be routed to the Internet Gateway.
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true # Automatically assign a public IP to instances launched in this subnet.

  tags = {
    Name = "public-subnet"
  }
}

# Create a route table for the public subnet.
# A route table contains a set of rules, called routes, that are used to
# determine where network traffic is directed.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # This route sends all outbound traffic (0.0.0.0/0) to the Internet Gateway.
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate the route table with the public subnet.
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Create a security group for the EC2 instance.
# A security group acts as a virtual firewall for your instance to control
# inbound and outbound traffic.
resource "aws_security_group" "web_server" {
  name        = "web-server-sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  # Allow inbound SSH traffic from anywhere (for management).
  # In a real production environment, you should restrict this to your IP.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound HTTP traffic from anywhere (for the web server).
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # '-1' means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-server-sg"
  }
}

# Find the latest Amazon Linux 2 AMI dynamically.
# This is a best practice to avoid using outdated, hardcoded AMI IDs.
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create the public EC2 instance.
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id

  # Associate the security group created above.
  vpc_security_group_ids = [aws_security_group.web_server.id]

  # This is a user data script that runs when the instance first boots.
  # It installs a simple Apache web server to display a "Hello World" page.
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "web-server-instance"
  }
}
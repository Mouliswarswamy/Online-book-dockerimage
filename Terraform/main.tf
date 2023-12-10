terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.30.0"
    }
  }
  /*backend "s3" {
    bucket = "valhallastatefile"
    key    = "terraform.tfstate"
    region = var.region
  }*/
}


provider "aws" {
  region = var.region  # Set your desired AWS region
}

# Create VPC
resource "aws_vpc" "valhalla_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "valhalla_vpc"
  }
}

# Create subnet
resource "aws_subnet" "valhalla_subnet" {
  vpc_id                  = aws_vpc.valhalla_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.avail_zone  # Set your desired availability zone
  map_public_ip_on_launch = true
  tags = {
    Name = "valhalla_subnet"
  }
}

resource "aws_subnet" "valhalla_subnet1" {
  vpc_id                  = aws_vpc.valhalla_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-south-1b"  # Set your desired availability zone
  map_public_ip_on_launch = true
  tags = {
    Name = "valhalla_subnet1"
  }
}

# Creating 1st private subnet 
resource "aws_subnet" "pr_subnet_1" {
  vpc_id                  = aws_vpc.valhalla_vpc.id
  cidr_block              = "10.0.2.0/27" #32 IPs
  map_public_ip_on_launch = false         # private subnet
  availability_zone       = "ap-south-1b"
}

# Internet Gateway
resource "aws_internet_gateway" "sh_gw" {
  vpc_id = aws_vpc.valhalla_vpc.id
}

# route table for public subnet - connecting to Internet gateway
resource "aws_route_table" "sh_rt_public" {
  vpc_id = aws_vpc.valhalla_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sh_gw.id
  }
}

# associate the route table with public subnet 1
resource "aws_route_table_association" "sh_rta1" {
  subnet_id      = aws_subnet.valhalla_subnet.id
  route_table_id = aws_route_table.sh_rt_public.id
}
# associate the route table with public subnet 2
resource "aws_route_table_association" "sh_rta2" {
  subnet_id      = aws_subnet.valhalla_subnet1.id
  route_table_id = aws_route_table.sh_rt_public.id
}

# Create security group
resource "aws_security_group" "valhall_sg" {
  name        = "valhalla_sg_group"
  description = "Allow TLS inbound traffic"
  vpc_id = aws_vpc.valhalla_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.valhalla_vpc.cidr_block]
    
  }
  ingress {
    description      = "Allow https request from anywhere"
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "valhalla_sg_group"
  }
}

# Create EC2 instance
resource "aws_instance" "my_instance" {
  ami             = var.ami_id[var.os_type]  # Set your desired AMI
  instance_type   = "t2.micro"               # Set your desired instance type
  key_name        = "Devops-nov"    # Set your key pair name

  subnet_id       = aws_subnet.valhalla_subnet.id
  security_groups  = [aws_security_group.valhall_sg.id]

  tags = {
    Name = "my-instance"
  }
}

# Create load balancer
resource "aws_lb" "my_lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.valhall_sg.id]
  subnets            = [aws_subnet.valhalla_subnet.id, aws_subnet.valhalla_subnet1.id]
  depends_on         = [aws_internet_gateway.sh_gw]

  enable_deletion_protection = false
}

# Create target group
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.valhalla_vpc.id
}

# Attach the target group to the load balancer
resource "aws_lb_target_group_attachment" "my_target_group_attachment" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.my_instance.id
}

# Create listener
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

# ASG with Launch template
resource "aws_launch_template" "sh_ec2_launch_templ" {
  name_prefix   = "sh_ec2_launch_templ"
  image_id      = var.ami_id[var.os_type] # To note: AMI is specific for each region
  instance_type = "t2.micro"
  

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = aws_subnet.valhalla_subnet1.id
    security_groups             = [aws_security_group.valhall_sg.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Autoscale-instance" # Name for the EC2 instances
    }
  }
}

resource "aws_autoscaling_group" "sh_asg" {
  # no of instances
  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  # Connect to the target group
  target_group_arns = [aws_lb_target_group.my_target_group.arn]

  vpc_zone_identifier = [ # Creating EC2 instances in private subnet
    aws_subnet.valhalla_subnet1.id
  ]

  launch_template {
    id      = aws_launch_template.sh_ec2_launch_templ.id
    version = "$Latest"
  }
}

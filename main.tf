data "aws_availability_zones" "az" {
    state = "available"
}

locals {
  az1 = data.aws_availability_zones.az.names[0]
  az2 = data.aws_availability_zones.az.names[1]
}

resource "aws_vpc" "vpc_1" {
  cidr_block = var.vpc_cidr
  

  tags = {
    Name       = var.vpc_name
    created_by = var.created_by
  }
}


resource "aws_internet_gateway" "IGW_byme" {
  vpc_id = aws_vpc.vpc_1.id
  
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "CustomRoute" {
  vpc_id = aws_vpc.vpc_1.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW_byme.id
  }

  tags = {
    Name = "${var.vpc_name}-public-route"
  }
}

resource "aws_route_table_association" "CustomRoute_association" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.CustomRoute.id
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.vpc_1.default_route_table_id
  tags = {
    Name = "defaultTable"
  }
}


resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.vpc_1.id
  cidr_block = var.az_subnet1
  availability_zone = local.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-subnet-${local.az1}-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc_1.id
  cidr_block = var.az_subnet2
  availability_zone = local.az2

  tags = {
    Name = "${var.vpc_name}-subnet-${local.az2}-private"
  }
}
resource "aws_route_table_association" "default" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_default_route_table.default.id
}


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

resource "aws_security_group" "main_sg" {
  vpc_id = aws_vpc.vpc_1.id
  name = "${var.vpc_name}-sg"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "public_instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.main_sg.id]

  tags = {
    Name = "public-ec2"
  }
}

resource "aws_instance" "private_instance" {

  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.main_sg.id]

  tags = {
    Name = "private-ec2"
  }
}

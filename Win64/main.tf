data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

variable "vpc_id" {
    default = "vpc-04b24f131865e4671"
}

variable "subnet_id" {
    default = "subnet-00ad9fa5351ca8e69"
}

variable "key_name" {
    #default = "chavessh"
    default = "chavessh"
}


resource "aws_security_group" "permitir_ssh" {
  name        = "permitir_ssh"
  description = "Permite SSH na instancia EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH to EC2"
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

  tags = {
    Name = "permitir_ssh"
  }
}

resource "aws_instance" "webserver1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = var.key_name
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.permitir_ssh.id]
  associate_public_ip_address = true

  tags = {
    Name = "webserver1"
  }
}


resource "aws_instance" "webserver2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = var.key_name
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.permitir_ssh.id]
  associate_public_ip_address = true

  tags = {
    Name = "webserver2"
  }
}
terraform {
required_providers {
    aws = {
    source  = "hashicorp/aws"
    version = "~> 4.16"
    }
    }
    required_version = ">= 1.2.0"
}
provider "aws" {
    region  = "us-east-1"
}


#VPC
resource "aws_vpc" "Main" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name= "Main VPC"
    }
}

#Internet Gateway 
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.Main.id
}


#Route Table 
resource "aws_route_table" "Main-RT" {
    vpc_id = aws_vpc.Main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    route {
        ipv6_cidr_block        = "::/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    tags = {
        Name = "Main-RT "
    }
}
resource "aws_route_table_association" "Associate" {
    route_table_id = aws_route_table.Main-RT.id
    subnet_id = aws_subnet.Sub1.id
}

#Subnet
resource "aws_subnet" "Sub1" {
    vpc_id = aws_vpc.Main.id
    availability_zone = "us-east-1a"
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "Public Subnet" 
    }
}


#Security Group
resource "aws_security_group" "WebTraffice" {
    name = "Allow Web traffic "
    description = "Allow web inbound traffic and all outbound traffic"
    vpc_id = aws_vpc.Main.id

    ingress {
        description = "HTTPS"
        protocol  = "tcp"
        from_port = 443
        to_port   = 443
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTP"
        protocol  = "tcp"
        from_port = 80
        to_port   = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "SSH"
        protocol  = "tcp"
        from_port = 22
        to_port   = 22
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


#Network Interface
resource "aws_network_interface" "web-server-nic" {
    subnet_id       = aws_subnet.Sub1.id
    private_ips     = ["10.0.1.50"]
    security_groups = [aws_security_group.WebTraffice.id]

}

#elastic IP
resource "aws_eip" "EIP" {
    vpc = true
    network_interface = aws_network_interface.web-server-nic.id
    associate_with_private_ip = "10.0.1.50"
    depends_on = [ aws_internet_gateway.gw , aws_instance.web-server]

    tags = {
        Name = "eip"
    }

}

resource "aws_instance" "web-server" {
    ami = "ami-04b70fa74e45c3917"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "key"
    network_interface {
        network_interface_id = aws_network_interface.web-server-nic.id
        device_index = 0
    }
    user_data = <<-EOF
            #!/bin/bash
            sudo apt update -y
            sudo apt install apache2 -y
            sudo systemctl start
            sudo echo -c "Web server is working" > /var/www/html/index.html
            EOF
    tags = {
        Name = "Webserver"
    }
}
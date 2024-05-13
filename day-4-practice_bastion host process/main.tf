#create vpc
resource "aws_vpc" "sai" {
    cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

#create public subnet
resource "aws_subnet" "public" {
   vpc_id = aws_vpc.sai.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    tags = {
      Name = "my-pub"
    }
  
}

#create private subnet
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.sai.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
    tags = {
      Name = "my-pvt"
    }
  
}

#create internet gatway
resource "aws_internet_gateway" "sai" {
    vpc_id = aws_vpc.sai.id
    tags = {
      Name = "my-ig"
    }
  
}

#create elastic ip
resource "aws_eip" "sai" {
    domain = "vpc"
  
}

# create nat gatway
resource "aws_nat_gateway" "sai" {
    subnet_id = aws_subnet.public.id
    allocation_id = aws_eip.sai.id
    tags = {
      Name = "my-nat"
    }
  
}

#create pubic RT and edit route for IG
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.sai.id
    tags = {
      Name = "my-pub"
    }
    route{
        gateway_id = aws_internet_gateway.sai.id
        cidr_block = "0.0.0.0/0"
    }
  
}

#create private RT and edit route for NAT
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.sai.id
    tags = {
      Name = "my-pvt"
    }
    route{
        nat_gateway_id = aws_nat_gateway.sai.id
        cidr_block = "0.0.0.0/0"
    }
  
}

#edit subnet associations with public subnet
resource "aws_route_table_association" "public" {
    route_table_id = aws_route_table.public.id
    subnet_id = aws_subnet.public.id
  
}

#edit subnet associations with private subnet
resource "aws_route_table_association" "private" {
    route_table_id = aws_route_table.private.id
    subnet_id = aws_subnet.private.id
  
}

#create security groups
resource "aws_security_group" "sai" {
    vpc_id = aws_vpc.sai.id
    tags = {
      Name = "my-sg"
    }
    ingress{
        description = "TCL from VPC"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
  ingress{
        description = "TCL from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
     egress{
        description = "TCL from VPC"
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = [ "0.0.0.0/0" ]
     }
}

#create public ec2
resource "aws_instance" "public" {
    ami = "ami-013e83f579886baeb"
    instance_type = "t2.micro"
    key_name = "sss"
    subnet_id = aws_subnet.public.id
    availability_zone = "ap-south-1a"
    associate_public_ip_address = true
    vpc_security_group_ids = [ aws_security_group.sai.id ]
    tags = {
      Name = "my-pub"
    }
  
}

#create private ec2
resource "aws_instance" "private" {
    ami = "ami-013e83f579886baeb"
    instance_type = "t2.micro"
    key_name = "sss"
    subnet_id = aws_subnet.private.id
    availability_zone = "ap-south-1a"
    associate_public_ip_address = false
    vpc_security_group_ids = [ aws_security_group.sai.id ]
    tags = {
      Name = "my-pvt"
    }
  
}
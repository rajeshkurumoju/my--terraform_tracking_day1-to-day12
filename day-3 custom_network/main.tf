# create vpc
resource "aws_vpc" "raj" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "my vpc"
    }
  
}
  # create subnet
  resource "aws_subnet" "raj" {
    vpc_id = aws_vpc.raj.id
    availability_zone = "ap-south-1a"
    cidr_block = "10.0.0.0/24"
    tags = {
      Name = "my_subnet"
    }
    
  }

  # create internet gatway attch vpc
  resource "aws_internet_gateway" "raj" {
    vpc_id = aws_vpc.raj.id
    
    
  }

  #create route table and edit routes and configure internet gatway
  resource "aws_route_table" "raj" {
    vpc_id = aws_vpc.raj.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.raj.id
        
    }
    
  }

  #create subnet associations into add RT (public)
  resource "aws_route_table_association" "raj" {
    subnet_id = aws_subnet.raj.id
    route_table_id = aws_route_table.raj.id
    
  }

  resource "aws_security_group" "raj" {
     vpc_id = aws_vpc.raj.id
    tags = {
      Name = "my_sg"

  }
   

    
    ingress {
        description = "TCL from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "TCL from VPC"
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
  }
  #create ec2 instance
   resource "aws_instance" "raj" {
    ami = var.ami
    instance_type = var.instance_type
    availability_zone = "ap-south-1a"
    key_name = var.keyname
    vpc_security_group_ids = [ aws_security_group.raj.id ]
    subnet_id = aws_subnet.raj.id
    tags = {
      Name = "sai"
    }
     
   }
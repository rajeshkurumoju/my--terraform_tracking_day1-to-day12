#create vpc
resource "aws_vpc" "raj" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}
#create public subnet
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.raj.id
  availability_zone = "ap-south-1a"
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "my-pub"
  }
}
#create private subnet
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.raj.id
    availability_zone = "ap-south-1a"
    cidr_block = "10.0.1.0/24"
    tags = {
      Name = "my-pvt"
    }
  
}
#create internet gatway
resource "aws_internet_gateway" "ig" {
    vpc_id = aws_vpc.raj.id
    tags = {
      Name = "my-ig"
    }
  
}

#create elastic ip
resource "aws_eip" "nat_gatway" {
    domain = "vpc"
  
}

#create nat gateway
resource "aws_nat_gateway" "raj" {
    subnet_id = aws_subnet.public.id
  allocation_id = aws_eip.nat_gatway.id
   tags = {
     Name = "my-nat"
   }
}
# create route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.raj.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "my-pub"
  }
}

#create private routetable
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.raj.id
    route{
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.raj.id
    }
  tags = {
    Name = "my-pvt-rt"
  }
}

#edit public subnet association
resource "aws_route_table_association" "public" {
    route_table_id = aws_route_table.public.id
    subnet_id = aws_subnet.public.id
  
}

#edit private subnet association
resource "aws_route_table_association" "private" {
    route_table_id = aws_route_table.private.id
    subnet_id = aws_subnet.private.id
  
}

#create security group
resource "aws_security_group" "raj" {
    vpc_id = aws_vpc.raj.id
    tags = {
      Name = "my-sg"
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

#create public ec2
resource "aws_instance" "pub" {
    ami = "ami-013e83f579886baeb"
    instance_type = "t2.micro"
  key_name = "sss"
  subnet_id = aws_subnet.public.id
  availability_zone = "ap-south-1a"
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.raj.id ]
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
  vpc_security_group_ids = [ aws_security_group.raj.id ]
  tags = {
    Name = "my-pvt"
  }
}


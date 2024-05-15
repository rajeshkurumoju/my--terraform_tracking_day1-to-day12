
#create vpc
resource "aws_vpc" "raj" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "my-vpc"
    }
  
}

# create subnets with different availability zones
resource "aws_subnet" "raj1" {
    vpc_id = aws_vpc.raj.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    tags = {
      Name = "my-pub1"
    }
  
}

# create subnets with different availability zones
resource "aws_subnet" "raj2" {
    vpc_id = aws_vpc.raj.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1b"
    tags = {
      Name = "my-pub2"
    }
  
}


#create internet gateway
resource "aws_internet_gateway" "raj" {
    vpc_id = aws_vpc.raj.id
    tags = {
      Name = "my-ig"
    }
  
}

#create route table and edit routes
resource "aws_route_table" "raj" {
    vpc_id = aws_vpc.raj.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.raj.id
    }
  
}

#edit subnet association-raj1
resource "aws_route_table_association" "raj1" {
    route_table_id = aws_route_table.raj.id
    subnet_id = aws_subnet.raj1.id
  
}

#edit subnet association-raj2
resource "aws_route_table_association" "raj2" {
    route_table_id = aws_route_table.raj.id
    subnet_id = aws_subnet.raj2.id
  
}

#create security groups
resource "aws_security_group" "raj" {
    vpc_id = aws_vpc.raj.id
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

#create instance for different availability zones
resource "aws_instance" "raj1" {
    ami = "ami-013e83f579886baeb"
    count = 2
    instance_type = "t2.micro"
    key_name = "sss"
    subnet_id = aws_subnet.raj1.id
    availability_zone = "ap-south-1a"
    vpc_security_group_ids = [ aws_security_group.raj.id ]
    associate_public_ip_address = true
    tags = {
      Name = "raj1"
    }
  
}



#create ami
resource "aws_ami_from_instance" "raj" {
    name = "my-ami"
    source_instance_id = "i-0f3190e0a89db13f5"
    tags = {
      Name = "my-ami"
    }

  
}

#create lanuch template
resource "aws_launch_configuration" "raj" {
   image_id = aws_ami_from_instance.raj.id
   instance_type = "t2.micro"
   key_name = "sss"
   security_groups = [ "${aws_security_group.raj.id}" ]
   associate_public_ip_address = true
  
}

# create target group
resource "aws_lb_target_group" "raj" {
    name = "my-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.raj.id
    
    

}
# instances attach to target group
resource "aws_lb_target_group_attachment" "raj" {
    target_group_arn = aws_lb_target_group.raj.arn
    count = 2
    target_id = aws_instance.raj1[count.index].id
  port = 80
}

# create load balncer
resource "aws_lb" "raj" {
    name = "my-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [ aws_security_group.raj.id ]
subnets = [ aws_subnet.raj1.id,aws_subnet.raj2.id ]
enable_deletion_protection = false
  
}

# Attach the target group to the ALB
resource "aws_lb_target_group_attachment" "target_alb" {
  target_group_arn  = aws_lb_target_group.raj.arn
  target_id         = aws_lb.raj.arn
  port              = 80
}


#create autoscalling group
resource "aws_autoscaling_group" "raj" {
name = "my-asg"
capacity_rebalance = true
desired_capacity = 2
max_size = 5
min_size = 1
vpc_zone_identifier = [ aws_subnet.raj1.id,aws_subnet.raj2.id ]
launch_configuration = aws_launch_configuration.raj.id
target_group_arns = [ "${aws_lb_target_group.raj.arn}" ]

}

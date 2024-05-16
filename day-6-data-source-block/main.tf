data "aws_subnet" "data-source" {
    filter {
      name = "tag:Name"
      values = [ "subnet-1" ]
    }
  
}

# create ec2 and for example for subnet for data-source
resource "aws_instance" "raj" {
  ami           = "ami-013e83f579886baeb"
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.data-source.id
  key_name      = "sss"
  tags = {
    Name = "rajesh"
  }
}
resource "aws_instance" "ebbu" {
  ami = "ami-0cc9838aa7ab1dce7"
  instance_type = "t2.micro"
  tags = {
    Name = "raj"
  }
}





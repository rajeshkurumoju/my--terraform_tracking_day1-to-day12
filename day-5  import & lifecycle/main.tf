
#example import for instance existing network create from remote to local terraform and it will create statefile inside floder at local
resource "aws_instance" "ebbu" {
  ami = "ami-0cc9838aa7ab1dce7"
  instance_type = "t2.micro"
  tags = {
    Name = "raj"
  }
}





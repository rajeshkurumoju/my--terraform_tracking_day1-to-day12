resource "aws_instance" "raj" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.keyname
  tags = {
    Name = "raj"
  }
}
#resource "aws_s3_bucket" "name" {
  #bucket = "duihiuhdsdwf"
  
#}

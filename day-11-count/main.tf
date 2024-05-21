resource "aws_instance" "raj" {
  ami           = "ami-013e83f579886baeb"
  instance_type = "t2.micro"
  key_name      = "sss"
  count = length(var.sandbox)
  tags = {
    Name = var.sandbox[count.index]
  }
}

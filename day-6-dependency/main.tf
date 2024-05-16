resource "aws_instance" "raj" {
  ami = "ami-0cc9838aa7ab1dce7"
  instance_type = "t2.micro"
  key_name = "sss"
  tags = {
    Name = "db"
  }
  depends_on = [ aws_s3_bucket.raj ]
}


# dependency example for s3 first create for s3
resource "aws_s3_bucket" "raj" {
    bucket = "dependency-s3"
  
}
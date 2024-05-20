#create public key_pair in local
resource "aws_key_pair" "raj" {
  key_name   = "public"
 public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIK1otx/NcMDGCHI+cTvki+NM7HfUlWmQKArUBkZTaw3 kurum@MSI"

}

#create ec2 instance
resource "aws_instance" "raj" {
  ami = "ami-013e83f579886baeb"
  instance_type = "t2.micro"
  key_name = aws_key_pair.raj.key_name
  tags = {
    Name = "raj"
 }
}

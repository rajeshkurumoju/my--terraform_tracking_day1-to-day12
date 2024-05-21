provider "aws" {
  region = "ap-south-1"  # Ensure to replace this with your desired AWS region
}
resource "aws_key_pair" "raj" {
  key_name   = "public"
 public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIK1otx/NcMDGCHI+cTvki+NM7HfUlWmQKArUBkZTaw3 kurum@MSI"

}




resource "aws_instance" "raj" {
  ami           = "ami-013e83f579886baeb"
  instance_type = "t2.micro"
 key_name = aws_key_pair.raj.key_name

  tags = {
    Name = "ebbu"
  }

  provisioner "local-exec" {
    command = "touch file500"
  }

  provisioner "file" {
    source      = "file100"  # Ensure this file exists on your local machine
    destination = "/home/ec2-user/file100"  # Adjust the destination path if necessary
  }

  provisioner "remote-exec" {
    inline = [
      "touch /home/ec2-user/file200",
      "echo hello from aws >> /home/ec2-user/file200",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"  # Replace with the appropriate username for your EC2 instance (e.g., 'ubuntu' for Ubuntu AMIs)
    private_key = file("C:/Users/kurum/.ssh/id_ed25519")
    host        = self.public_ip
  }
}



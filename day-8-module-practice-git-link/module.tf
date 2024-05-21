module "git" {
    source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance"
  ami = "ami-013e83f579886baeb"
  instance_type = "t2.micro"
  key_name = "sss"
}
output "ip" {
    value = aws_instance.raj.public_ip
    description = "calling public ip for ec2 instance"
  
}
output "privateip" {
    value = aws_instance.raj.private_ip
    description = "calling private ip for ec2 instance"
    sensitive = true
 
}
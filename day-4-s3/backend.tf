terraform {
  backend "s3" {
    bucket = "remote-s3-state-file1"
    key = "terraform.tfstate"
    region = "ap-south-1"
     dynamodb_table = "terraform-state-lock-dynamo"
    encrypt = true

   
}
}



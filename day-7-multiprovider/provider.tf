provider "aws" {
    region = "ap-south-1"
  
}

#create another region
provider "aws" {
    region = "us-east-1"
    alias = "rajesh"
  
}
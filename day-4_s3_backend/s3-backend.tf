terraform {
  backend "s3" {
    bucket = "remote-s3-local"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}


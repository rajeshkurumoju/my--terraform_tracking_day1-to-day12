
locals {
  bucket-name = "${var.layer}-${var.env}-mkprs"
}

resource "aws_s3_bucket" "raj" {

 # bucket = "raj-kumar-mkprs"
    # bucket = "${var.layer}-${var.env}-mkprs

    bucket = local.bucket-name
  tags = {
        # Name = "${var.layer}-${var.env}-mkprs"
        Name = local.bucket-name
        Environment = var.env
    }
    
}
variable "ami" {
  type    = string
  default = "ami-013e83f579886baeb"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "sandboxes" {
  type    = list(string)
  default = ["raj","mkprs"]
}
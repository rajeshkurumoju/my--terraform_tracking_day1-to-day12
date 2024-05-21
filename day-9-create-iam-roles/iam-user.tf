resource "aws_iam_user" "raj" {
    name = "raj"
  
}

resource "aws_iam_access_key" "raj" {
    user = aws_iam_user.raj.name
  
}
output "access_key_id" {
  value = aws_iam_access_key.raj.id
}

output "secret_access_key" {
  value = aws_iam_access_key.raj.secret
  sensitive = true
}


resource "aws_iam_user_policy_attachment" "raj" {
    user = aws_iam_user.raj.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  
}
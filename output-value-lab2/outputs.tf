output "instance_id" {
  value = aws_instance.my-instance-1.id
}

output "instance_id2" {
  value = aws_instance.my-instance-2.id
}

output "arn1" {
  value = aws_instance.my-instance-1.arn

}


output "arn2" {
  value = aws_instance.my-instance-2.arn
  
}
output "instance-1-private-ip" {
    value = aws_instance.my-instance-1.private_ip
    description = "private IP for the instance 1"
  
}

output "instance-2-private-ip" {
    value = aws_instance.my-instance-2.private_ip
    description = "private IP for the instance 2"
  
}
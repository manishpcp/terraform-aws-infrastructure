output "instance_id" {
  value = aws_instance.main.id
}

output "private_ip" {
  value = aws_instance.main.private_ip
}

output "availability_zone" {
  value = aws_instance.main.availability_zone
}

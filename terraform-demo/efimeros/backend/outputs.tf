output "instance_ip_addresses" {
  value = aws_instance.ansible_backend.*.private_ip
}

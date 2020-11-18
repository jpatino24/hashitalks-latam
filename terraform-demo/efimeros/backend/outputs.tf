output "instance_ip_addresses" {
  value = aws_instance.ansible_backend.*.private_ip
}

output "ami_backend" {
  value = data.aws_ami_ids.backend.ids[0]
}
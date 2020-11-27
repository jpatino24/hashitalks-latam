output "instance_ip_addresses" {
  value = aws_instance.ansible_backend.*.private_ip
}

output "ami_backend" {
  value = data.aws_ami.backend.id
}

output "snapshot_ami" {
  value = data.aws_ami.backend.root_snapshot_id
}
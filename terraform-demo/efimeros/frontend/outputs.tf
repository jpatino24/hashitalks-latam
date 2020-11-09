output "instance_ip_addresses" {
  value = aws_instance.ansible_frontend.*.public_ip
}

output "SSH" {
  value = {
    for instance in aws_instance.ansible_frontend :
    instance.id => "ssh -i aws_key/workshop_key.pem ec2-user@${instance.public_ip}"
  }
}
output "instance_ip_addresses" {
  value = aws_instance.ansible_frontend.*.public_ip
}

output "public_dns" {
  value = aws_instance.ansible_frontend.*.public_dns
}

output "proxy_stats" {
  value = {
    for dns in aws_instance.ansible_frontend :
    dns.id => "${dns.public_dns}:8080/haproxy?stats"
  }
}

output "SSH" {
  value = {
    for instance in aws_instance.ansible_frontend :
    instance.id => "ssh -i aws_key/workshop_key.pem ec2-user@${instance.public_ip}"
  }
}
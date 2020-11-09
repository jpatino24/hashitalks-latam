resource "local_file" "inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl",
    {
      node_ip = aws_instance.ansible_frontend.*.public_ip
    }
  )
  filename = "./ansible/inventory"
}
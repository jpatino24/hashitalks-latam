resource "local_file" "inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl",
    {
      node_ip = aws_instance.ansible_backend.*.private_ip
    }
  )
  filename = "./ansible/inventory"
}
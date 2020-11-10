resource "local_file" "inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl",
    {
      node_ip = aws_instance.ansible_frontend.*.public_ip
      webs_ip = data.terraform_remote_state.backend.outputs.instance_ip_addresses
    }
  )
  filename = "./ansible/inventory"
}
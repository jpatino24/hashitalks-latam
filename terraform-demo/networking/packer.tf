locals {
  rendered_packer = templatefile("templates/packer.cfg", {
    region          = var.region
    vpc_id          = module.vpc.main_vpc_id[0]
    subnet_id       = module.subnets.public_subnet_id[0]
    delete_snapshot = var.delete_snapshot
  })
}

resource "local_file" "packer_json" {
  content         = local.rendered_packer
  filename        = "../../packer-demo/packer.json"
  file_permission = "0640"
}
terraform {
  required_version = ">= 0.12"
}

# Create KeyPair

resource "tls_private_key" "backend_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.backend_key.public_key_openssh

  tags = {
    Name        = var.tag_name
    Environment = var.tag_env
    Proyect     = var.tag_project
    Responsable = var.tag_responsable
  }
}

# Get packer image

data "aws_ami_ids" "backends" {
  owners = ["self"]

  filter {
    name   = "name"
    values = ["My apache*"]
  }
}

data "aws_ami" "backend" {
  owners = ["self"]

  filter {
    name   = "name"
    values = ["My apache*"]
  }
}

# Rendered templates vars

locals {
  rendered_key_pair_pub = templatefile("templates/id_rsa_pub.cfg", {
    public_key = aws_key_pair.generated_key.public_key
  })
  rendered_key_pair_private = templatefile("templates/id_rsa.cfg", {
    private_key = tls_private_key.backend_key.private_key_pem
  })
  rendered_ami_id = templatefile("templates/Makefile.cfg", {
    ami_id   = data.aws_ami.backend.id
    region   = var.region
    snapshot = data.aws_ami.backend.root_snapshot_id
  })
}

# Create Keys

resource "local_file" "id_rsa_pub" {
  content         = local.rendered_key_pair_pub
  filename        = "./aws_key/backend_rsa.pub"
  file_permission = "0640"
}

resource "local_file" "id_rsa" {
  content         = local.rendered_key_pair_private
  filename        = "./aws_key/backend_key.pem"
  file_permission = "0600"
}

# Create Make Vars

resource "local_file" "make_vars" {
  content         = local.rendered_ami_id
  filename        = "../../../packer-demo/Makefile"
  file_permission = "0640"
}

# Remote state

data "terraform_remote_state" "networking" {
  backend = "local"

  config = {
    path = "../../networking/terraform.tfstate"
  }
}

resource "aws_instance" "ansible_backend" {
  count                  = var.instance_number
  ami                    = data.aws_ami.backend.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_backend.id]
  subnet_id              = data.terraform_remote_state.networking.outputs.private_subnet_id[0]
  key_name               = var.key_name
  depends_on = [
    aws_security_group.allow_backend,
    aws_key_pair.generated_key
  ]

  tags = {
    Name        = "tf-${var.tag_name}-${var.tag_env}-backend-${count.index + 1}"
    Environment = var.tag_env
    Proyect     = var.tag_project
    Responsable = var.tag_responsable
  }
}
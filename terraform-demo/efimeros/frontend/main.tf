terraform {
  required_version = ">= 0.12"
}

# Create KeyPair

resource "tls_private_key" "workshop_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.workshop_key.public_key_openssh

  tags = {
    Name        = var.tag_name
    Environment = var.tag_env
    Proyect     = var.tag_project
    Responsable = var.tag_responsable
  }
}

# Create Keys

locals {
  rendered_key_pair_pub = templatefile("templates/id_rsa_pub.cfg", {
    public_key = aws_key_pair.generated_key.public_key
  })
  rendered_key_pair_private = templatefile("templates/id_rsa.cfg", {
    private_key = tls_private_key.workshop_key.private_key_pem
  })
}

resource "local_file" "id_rsa_pub" {
  content         = local.rendered_key_pair_pub
  filename        = "./aws_key/workshop_rsa.pub"
  file_permission = "0640"
}

resource "local_file" "id_rsa" {
  content         = local.rendered_key_pair_private
  filename        = "./aws_key/workshop_key.pem"
  file_permission = "0600"
}

# Remote state

data "terraform_remote_state" "networking" {
  backend = "local"

  config = {
    path = "../../networking/terraform.tfstate"
  }
}

data "terraform_remote_state" "backend" {
  backend = "local"

  config = {
    path = "../backend/terraform.tfstate"
  }
}

# Create Instance

resource "aws_instance" "ansible_frontend" {
  count                  = var.instance_number
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_frontend.id]
  subnet_id              = data.terraform_remote_state.networking.outputs.public_subnet_id[0]
  key_name               = var.key_name
  depends_on = [
    aws_security_group.allow_frontend,
    aws_key_pair.generated_key
  ]

  tags = {
    Name        = "tf-${var.tag_name}-${var.tag_env}-server-${count.index + 1}"
    Environment = var.tag_env
    Proyect     = var.tag_project
    Responsable = var.tag_responsable
  }
}
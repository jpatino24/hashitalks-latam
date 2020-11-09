terraform {
  required_version = ">= 0.12"
}

# Random project name
resource "random_id" "project_name" {
  byte_length = 4
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
    Name        = "${var.tag_name}"
    Environment = "${var.tag_env}"
    Proyect     = "${var.tag_project}"
    Responsable = "${var.tag_responsable}"
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
  filename        = "./aws_key/Ansible_workshop_key.pem"
  file_permission = "0600"
}

# Remote state

data "terraform_remote_state" "networking" {
    backend = "local"

    config = {
      path = "../networking/terraform.tfstate"
    }
}

resource "aws_instance" "ansible_frontend" {
    count                  = var.instance_number
    ami                    = var.ami_id
    instance_type          = var.instance_type
    vpc_security_group_ids = [aws_security_group.allow_frontend_ansible.id]
    subnet_id              = data.terraform_remote_state.networking.outputs.public_subnet_id
    key_name               = "Ansible_frontend_key"
    depends_on = [
      aws_security_group.allow_instructor_ansible,
      aws_key_pair.generated_key
    ]

    tags = {
      Name = "tf-${var.proyect}-${var.environment}-server-${count.index + 1}"
      Environment = "${var.tag_env}"
      Proyect     = "${var.tag_project}"
      Responsable = "${var.tag_responsable}"
    }
}
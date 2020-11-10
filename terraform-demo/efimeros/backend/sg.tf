resource "aws_security_group" "allow_backend" {
  name        = "allow_backend"
  description = "Allow inbound traffic to workshop"
  vpc_id      = data.terraform_remote_state.networking.outputs.main_vpc_id[0]

  ingress {
    description = "SSH Port for backend Instances"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.networking.outputs.main_cidr_block[0]]
  }

  ingress {
    description = "HTTP Port for backend Instances"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.networking.outputs.main_cidr_block[0]]
  }

ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [data.terraform_remote_state.networking.outputs.main_cidr_block[0]]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "tf-${var.tag_name}-${var.tag_env}-sg-backend"
    Environment = var.tag_env
    Proyect     = var.tag_project
    Responsable = var.tag_responsable
  }
}
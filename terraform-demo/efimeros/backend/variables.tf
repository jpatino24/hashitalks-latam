variable "region" {
  description = "AWS region"
}

variable "instance_number" {
  description = "Number of ec2 instances"
}

#variable "ami_id" {
#  description = "ID of the AMI to provision."
#}

variable "instance_type" {
  description = "type of EC2 instance to provision."
}

variable "key_name" {
  description = "Aws Keypair resource Name"
}

variable "tag_name" {
  description = "AWS Tag Name"
}

variable "tag_env" {
  description = "AWS Tag Environment"
}

variable "tag_project" {
  description = "AWS Tag Project"
}

variable "tag_responsable" {
  description = "AWS Tag Responsable"
}
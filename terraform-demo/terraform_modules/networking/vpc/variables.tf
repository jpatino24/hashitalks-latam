#-------------------------------
# GENERAL VARIABLES DECLARATION
#-------------------------------
variable "prefix" {
  type        = string
  default     = "tf"
  description = "prefijo para los nombres de los recursos desplegados con Terraform"
}
variable "proyect" {
  type        = string
  description = "Proyecto para el cual se desarrollo la solucion"
}
variable "environment" {
  type        = string
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}
variable "application" {
  type        = string
  default     = ""
  description = "Aplicacion"
}
variable "tags" {
  type        = map
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`, `XYZ`)."
}

#------------------
# MODULE VARIABLES
#------------------
##REQUERIMENTS
variable "create_vpc" {
  type = bool
}
variable "create_internet_gateway" {
  type    = bool
  default = true
}
variable "create_default_network_acl" {
  type    = bool
  default = true
}
variable "enable_dns_support" {
  type    = bool
  default = false
}
variable "enable_dns_hostnames" {
  type    = bool
  default = false
}
variable "cidr_vpc" {
  type = string
}
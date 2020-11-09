#-------------------------------
# GENERAL VARIABLES DECLARATION
#-------------------------------
variable "region" {
  description = "AWS region"
  default     = "us-east-2"
}

variable "prefix" {
  description = "prefijo"
  default     = "tf"
}

variable "technology" {
  description = "Tecnología de Despliegue"
  default     = "Terraform"
}

variable "client" {
  default = "hashitalks"
}

variable "area" {
  default = "infraestructura"
}

variable "responsable" {
  default = "infraestructura"
}

variable "proyect" {
  default = "demo"
}

variable "environment" {
  default = "pruebas"
}

#-------------------------------
# MODULES VARIABLES DECLARATION
#-------------------------------
##-----
## VPC
##-----
variable "cidr_main_vpc" {
  type        = string
  description = "CIDR de la VPC"
}
variable "create_vpc" {
  type        = bool
  description = "¿Desea crear una VPC (true/false)?"
}
variable "create_internet_gateway" {
  type        = bool
  description = "¿Desea crear un Internet Gateway (true/false)?"
}
variable "create_default_network_acl" {
  type        = bool
  description = "¿Desea crear una Default ACL (true/false)?"
}
variable "enable_dns_support" {
  type        = bool
  description = "¿Desea habilitar la resolucion dns en su VPC (true/false)?"
}
variable "enable_dns_hostnames" {
  type        = bool
  description = "¿Desea habilitar la resolucion de hostnames publicos de las instancias con IP publicas (true/false)?"
}

variable "tags_vpc" {
  type        = map
  description = "TAGS de la VPC a convenir con el cliente para organizar facturacion."
}
##---------
## SUBNETS
##---------
variable "create_subnets_private" {
  type        = bool
  description = "¿Desea crear subredes privadas?"
}
variable "create_subnets_public" {
  type        = bool
  description = "¡Desea crear subredes privadas?"
}
variable "application_subnet" {
  type        = string
  description = "Aplicacion"
}
variable "cidr_block_subnets" {
  type        = string
  description = "CIDR para distribuir simetricamente entre las subredes"
}
variable "availability_zones_subnets" {
  type        = list
  description = "Lista de las zonas de disponibilidad que se desean utilizar para las subredes"
}
variable "nat_gateway_enabled" {
  type        = bool
  description = "¿Desea habilitar un NAT gateway (true/false)?"
}
variable "map_public_ip_on_launch" {
  type        = bool
  description = "¿Desea habilitar la asignacion automatica de IPs publicas sobre los recursos desplegados en las subredes publicas (true/false)?"
}
variable "tags_subnets" {
  type        = map
  description = "TAGS de las SUBNETS a convenir con el cliente para organizar facturacion."
}
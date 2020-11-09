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
  description = "Aplicacion"
}
variable "tags" {
  type        = map
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}
#------------------
# MODULE VARIABLES
#------------------
##REQUERIMENTS
variable "vpc_id" {
  type = string
}
variable "igw_id" {
  type = string
}

##SUBNETS GENERAL
variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}
variable "create_subnets_public" {
  type        = bool
  description = "¡Desea crear subredes publicas?"
}
variable "create_subnets_private" {
  type        = bool
  description = "¿Desea crear subredes privadas?"
}
variable "enable_acl" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}
variable "nat_gateway_enabled" {
  type        = bool
  default     = false
  description = "Flag to enable/disable NAT Gateways creation in public subnets."
}
variable "enable_flow_log" {
  type        = bool
  default     = false
  description = "Enable subnet_flow_log logs."
}
variable "availability_zones" {
  type        = list(string)
  default     = []
  description = "List of Availability Zones (e.g. `['us-east-1a', 'us-east-1b', 'us-east-1c']`)."
}
variable "cidr_block" {
  type        = string
  description = "Base CIDR block which is divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)."
}
#SUBNETS PUBLIC
variable "public_subnet_ids" {
  type        = list(string)
  default     = []
  description = "A list of public subnet ids."
}
variable "public_network_acl_id" {
  type        = string
  default     = ""
  description = "Network ACL ID that is added to the public subnets. If empty, a new ACL will be created."
}
variable "map_public_ip_on_launch" {
  type        = bool
  default     = true
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address."
}

#SUBNETS PRIVATE
variable "private_network_acl_id" {
  type        = string
  default     = ""
  description = "Network ACL ID that is added to the private subnets. If empty, a new ACL will be created."
}

##FLOW LOG
variable "s3_bucket_arn" {
  type        = string
  default     = ""
  description = "S3 ARN for vpc logs."
}
variable "traffic_type" {
  type        = string
  default     = "ALL"
  description = "Type of traffic to capture. Valid values: ACCEPT,REJECT, ALL."
}


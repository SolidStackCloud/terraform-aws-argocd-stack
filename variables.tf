variable "region" {
  description = "Região onde os recursos serão construídos"
  type        = string
}
variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "solidstack_vpc_module" {
  description = "Se true, o módulo usará os recursos (VPC, subnets, etc.) criados pelo módulo VPC da SolidStack, buscando-os no SSM Parameter Store. O 'project_name' deve ser o mesmo em ambos os módulos."
  type        = bool
  default     = true
}


variable "cluster_name" {
  default = ""
}

variable "dominio" {

}

variable "name" {
  type    = string
  default = "app_service"
}

variable "prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "cosmos_conn_string" {
  type = string
}

variable "docker_config" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "app_plan_tier" {
  description = "App Plan sku"
  type        = string

}
variable "app_plan_size" {
  description = "App Plan sku"
  type        = string

}

variable "name" {
  type    = string
  default = "func"
}

variable "prefix" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "cosmos_conn_string" {
  type = string
}

variable "builtin_logging" {
  type        = string
  description = "used to set the AzureWebJobsDashboard configuration setting, by default we use the application insights logging. This uses connection to Function storage account"
  default     = "false"
}

variable "key_vault_id" {
  type = string

}
variable "docker_config" {
  type = string
}

variable "tenant_id" {
  type = string
}

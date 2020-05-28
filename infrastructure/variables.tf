variable "prefix" {
  type        = string
  description = "prefix most resources and will be used as part of the storage account, so it needs to only be alphanumeric"
}

variable "resource_group_name" {
  type        = string
  description = "existing resource group name"
}

variable "cosmos_name" {
  type        = string
  description = "exist cosmosdb account name"
}

variable "location" {
  description = "The region where the resources are created."
  default     = "westus"
}

variable "image_tag" {
  description = "docker tag"
  default     = "latest"
}

variable "docker_name" {
  description = "docker user or organization name"
}

variable "docker_appservice_image" {
  description = "docker image for app service"
}

variable "docker_functionapp_image" {
  description = "docker image for function app"
}

/** available options
      size    tier
      B1      Basic
      B2      Basic
      B3      Basic
      S1      Standard
      S2      Standard
      S3      Standard
      P1      Premium
      P2      Premium
      P3      Premium
      P1V2    PremiumV2
      P2V2    PremiumV2
      P3V2    PremiumV2
  */

variable "app_plan_tier" {
  description = "App Plan sku"

  type    = string
  default = "Basic"

}
variable "app_plan_size" {
  description = "App Plan sku"

  type    = string
  default = "B1"

}

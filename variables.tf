variable "workload_name" {
  type        = string
  description = "Workload name used for generating default resource names."
  default     = "acmebot"

  validation {
    condition     = length(var.workload_name) <= 12
    error_message = "Keep the workload name short and sweet (max 12 characters)."
  }
}

variable "resource_group_name" {
  type        = string
  description = "Name of an existing resource group."
}

variable "location" {
  type        = string
  description = "Region to deploy the Azure resources within. Defaults to the resource group region."
  default     = ""
}

variable "resource_tags" {
  type        = map(string)
  description = "Tags that should be applied to the deployed resources."
  default     = {}
}

variable "inherit_resource_group_tags" {
  type        = bool
  description = "Enables or disables resource group tag inherition."
  default     = false
} 

variable "function_app_name" {
  type        = string
  description = "Name of the function app resource."
  default     = ""
}

variable "function_package_url" {
  type        = string
  description = "Package URL used for the function app code."
  default     = "https://shibayan.blob.core.windows.net/azure-keyvault-letsencrypt/v3/latest.zip"
}

variable "app_service_plan_name" {
  type        = string
  description = "Name of the app service plan resource."
  default     = ""
}

variable "application_insights_name" {
  type        = string
  description = "Name of the Application Insights resource."
  default     = ""
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account resource."
  default     = ""

  validation {
    condition     = length(var.storage_account_name) <= 24
    error_message = "Storage account names can't be longer than 24 characters."
  }
}

variable "key_vault_name" {
  type        = string
  description = "Name of the Key Vault resource."
  default     = ""

  validation {
    condition     = length(var.key_vault_name) <= 24
    error_message = "Key Vault names can't be longer than 24 characters."
  }
}

variable "key_vault_sku" {
  type        = string
  description = "SKU used for the created Key Vault."
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.key_vault_sku)
    error_message = "Key Vault SKU must be either Standard or Premium."
  }
}

variable "acme_mail_address" {
  type        = string
  description = "The email address used in ACME account registration."
}

variable "acme_endpoint" {
  type        = string
  description = "ACME endpoint used for issuing certificates."
  default     = "https://acme-v02.api.letsencrypt.org/"
}

variable "auth_client_name" {
  type        = string
  description = "Display name of the AD Auth application."
  default     = "Key Vault Acmebot"
}

variable "dns_zone_ids" {
  type        = list(string)
  description = "A list of resource IDs of the Azure DNS zones Key Vault Acmebot should manage."
  default     = []
}

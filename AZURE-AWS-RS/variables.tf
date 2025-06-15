variable "location" {
  description = "Região onde os recursos serão criados na Azure"
  type        = string
  default     = "East US"
}

variable "account_tier" {
  description = "Tier da Storage Account na Azure"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Tipo de replicação de dados na Storage Account"
  type        = string
  default     = "LRS"
}
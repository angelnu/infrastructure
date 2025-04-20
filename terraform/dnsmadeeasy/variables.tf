variable "api_key" {
  description = "DNS Made Easy API Key"
  type        = string
  default     = false
}

variable "secret_key" {
  description = "DNS Made Easy Secret Key"
  type        = string
  default     = false
}

variable "domains" {
  description = "DNS domains"
  type        = any
}

variable "domains_common" {
  description = "DNS common settings"
  type        = any
}

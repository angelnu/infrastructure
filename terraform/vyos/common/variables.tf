variable "config" {
  description = "vyos module config"
  type        = any
}

variable "config_raw" {
  description = "vyos module config for all instances"
  type        = any
}

variable "network_clients" {
  description = "List of network client objets"
  type        = map(list(map(string)))
}

variable "domains" {
  description = "DNS domains"
  type        = any
}

variable "domains_common" {
  description = "DNS common settings"
  type        = any
}


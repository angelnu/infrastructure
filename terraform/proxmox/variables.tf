variable "config" {
  description = "module config"
  type        = any
}

variable "network_clients" {
  description = "List of network client objets"
  type        = map(list(map(string)))
}

variable "lan_config" {
  description = "Lan config"
  type        = any
}
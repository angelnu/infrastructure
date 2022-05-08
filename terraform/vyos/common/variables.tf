variable "config" {
    description = "vyos module config" 
    type        = any
}

variable "config_global" {
    description = "vyos module global config" 
    type        = any
}

variable "network_clients" {
    description = "List of network client objets" 
    type        = map(list(map(string)))
}


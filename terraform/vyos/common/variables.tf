variable "config" {
    description = "vyos module config" 
    type        = any
}

variable "network_clients" {
    description = "List of network client objets" 
    type        = map(list(map(string)))
}


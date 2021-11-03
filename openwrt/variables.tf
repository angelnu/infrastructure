variable "network_clients" {
    description = "List of network client objets" 
    type        = list(map(string))
    default     = []
}

variable "router_IP" {
    description = "IP of the OpenWRT router" 
    type        = string
}

variable "router_ssh_key" {
    description = "ssh key of the OpenWRT router" 
    type        = string
    sensitive   = true
}

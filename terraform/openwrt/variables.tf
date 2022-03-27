variable "network_clients" {
    description = "List of network client objets" 
    type        = map(list(map(string)))
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

variable "dnsmasq_config_extra" {
    description = "extra settings for dnsmasq" 
    type        = string
}

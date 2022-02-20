variable "network_clients" {
    description = "List of network client objets" 
    type        = list(map(string))
    default     = []
}

variable "unifi_api_username" {
    description = "Unifi username" 
    type        = string
}

variable "unifi_api_password" {
    description = "Unifi password" 
    type        = string
}

variable "unifi_api_url" {
    description = "Unifi api_url" 
    type        = string
}

variable "unifi_api_insecure" {
    description = "Unifi insecure" 
    type        = bool
    default     = false
}

variable "unifi_wlan_password" {
    description = "Unifi wlan" 
    type        = string
}
variable "network_clients" {
    description = "List of network client objets" 
    type        = list(map(string))
    default     = []
}

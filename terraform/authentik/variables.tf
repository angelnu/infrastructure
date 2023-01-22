variable "authentik_api_url" {
    description = "Authentik api url" 
    type        = string
}

variable "authentik_api_token" {
    description = "Authentik api token" 
    type        = string
}

variable "authentik_api_insecure" {
    description = "Authentik insecure" 
    type        = bool
    default     = false
}
variable "authentik_users" {
    description = "Authentik users" 
    type        = any
}
variable "authentik_groups" {
    description = "Authentik groups" 
    type        = any
}

variable "main_home_domain" {
    description = "Home main domain" 
    type        = string
}

variable "authentik_config" {
    description = "Authentik config" 
    type        = any
}
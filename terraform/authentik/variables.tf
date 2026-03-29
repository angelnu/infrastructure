variable "cluster_settings" {
  description = "cluster_settings"
  type        = any
}
variable "authentik_users" {
  description = "Authentik users"
  type        = any
}
variable "authentik_groups" {
  description = "Authentik groups"
  type        = any
}

variable "cluster_domain" {
  description = "Cluster domain"
  type        = string
}

variable "cluster_short_domain" {
  description = "Cluster short domain"
  type        = string
}

variable "authentik_config" {
  description = "Authentik config"
  type        = any
}

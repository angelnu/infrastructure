terraform {
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "2025.12.1"
    }
  }
}

provider "authentik" {
  # Configuration options
  url   = var.cluster_settings.api.url
  token = var.cluster_settings.api.token
  # Optionally set insecure to ignore TLS Certificates
  insecure = var.cluster_settings.api.insecure
}



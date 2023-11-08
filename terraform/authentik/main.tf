terraform {
  required_providers {
    authentik = {
      source = "goauthentik/authentik"
      version = "2023.10.0"
    }
  }
}

provider "authentik" {
  # Configuration options
  url   = var.authentik_api_url
  token = var.authentik_api_token
  # Optionally set insecure to ignore TLS Certificates
  insecure = var.authentik_api_insecure
}



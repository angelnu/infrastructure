terraform {
  required_providers {
    dme = {
      source = "DNSMadeEasy/dme"
      version = "1.0.5"
    }
  }
}

provider "dme" {
  # dme Api key
  api_key    = var.api_key
  # dme secret key
  secret_key = var.secret_key
}

locals {

    domains = { for i, entry in var.domains: "${entry.url }" => entry }
}
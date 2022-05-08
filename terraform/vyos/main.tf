terraform {
  required_providers {
    vyos = {
      source = "Foltik/vyos"
      //source= "github.com/foltik/vyos"
      version = "0.3.1"
    }
  }
}

provider "vyos" {
  url = var.config.virtual1.api.url
  key = var.config.virtual1.api.key
  alias = "virtual1"
}

module "common_virtual1" {
  source = "./common"

  config = var.config.virtual1
  config_global = var.config
  network_clients = var.network_clients

  providers = {
    vyos = vyos.virtual1
  }
}


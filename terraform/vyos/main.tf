terraform {
  required_providers {
    vyos = {
      source = "Foltik/vyos"
      //source= "github.com/foltik/vyos"
      version = "0.3.1"
    }
  }
}


// Virtual 1
provider "vyos" {
  url = var.config.virtual1.api.url
  key = var.config.virtual1.api.key
  alias = "virtual1"
}

module "deepmerge_virtual1" {
  source  = "Invicton-Labs/deepmerge/null"
  maps = [
    var.config.common,
    var.config.virtual1
  ]
}
module "common_virtual1" {
  source = "./common"

  config = module.deepmerge_virtual1.merged
  network_clients = var.network_clients

  providers = {
    vyos = vyos.virtual1
  }
}


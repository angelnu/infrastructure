terraform {
  required_providers {
    vyos = {
      #source = "angelnu/vyos"
      source = "Foltik/vyos"
      version = "0.3.4"
    }
  }
}

// primary
provider "vyos" {
  url   = var.config.primary.api.url
  key   = var.config.primary.api.key
  alias = "primary"
}

module "deepmerge_primary" {
  source = "Invicton-Labs/deepmerge/null"
  maps = [
    var.config.common,
    var.config.primary
  ]
}
module "common_primary" {
  source = "./common"

  config          = module.deepmerge_primary.merged
  config_raw      = var.config
  network_clients = var.network_clients
  domains         = var.domains
  domains_common  = var.domains_common

  providers = {
    vyos = vyos.primary
  }
}

// Secondary
provider "vyos" {
  url   = var.config.secondary.api.url
  key   = var.config.secondary.api.key
  alias = "secondary"
}

module "deepmerge_secondary" {
  source = "Invicton-Labs/deepmerge/null"
  maps = [
    var.config.common,
    var.config.secondary
  ]
}
module "common_secondary" {
  source = "./common"

  config          = module.deepmerge_secondary.merged
  config_raw      = var.config
  network_clients = var.network_clients
  domains         = var.domains
  domains_common  = var.domains_common
  providers = {
    vyos = vyos.secondary
  }
}


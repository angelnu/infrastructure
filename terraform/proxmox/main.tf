terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc09"
    }
    linux = {
      source  = "TelkomIndonesia/linux"
      version = "0.7.1"
    }
    htpasswd = {
      source  = "loafoe/htpasswd"
      version = "2.1.0"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.config.api_url
  #pm_api_token_id    = var.config.token.id
  #pm_api_token_secret = var.config.token.secret
  pm_user     = var.config.crendentials.user
  pm_password = var.config.crendentials.password
}

provider "linux" {
  host        = "pve1"
  port        = 22
  user        = "root"
  private_key = file(pathexpand("~/.ssh/id_ed25519"))
  password    = var.config.crendentials.password
}

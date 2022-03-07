terraform {
  required_providers {
    linux = {
      source = "TelkomIndonesia/linux"
      version = "0.7.0"
    }
  }
}

provider "linux" {
   host        = var.router_IP
    port     = 22
    user     = "root"
    private_key = var.router_ssh_key
}

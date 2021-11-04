
terraform {
  required_providers {
    sops = {
      source = "carlpett/sops"
      version = "0.6.3"
    }
  }
}

locals {
  network_clients = csvdecode(file("${path.module}/settings/network_clients.csv"))
}

data "sops_file" "settings_secrets" {
  source_file = "${path.module}/settings/secrets.yaml"
}

module "unifi" {
  source = "./unifi"

  network_clients     = local.network_clients
  unifi_api_url       = data.sops_file.settings_secrets.data["unifi.api.url"]
  unifi_api_insecure  = data.sops_file.settings_secrets.data["unifi.api.insecure"]
  unifi_api_username  = data.sops_file.settings_secrets.data["unifi.api.username"]
  unifi_api_password  = data.sops_file.settings_secrets.data["unifi.api.password"]
  unifi_wlan_password = data.sops_file.settings_secrets.data["unifi.wlan.password"]
}

module "openwrt" {
  source = "./openwrt"

  network_clients = local.network_clients
  router_IP       = "192.168.2.1"
  router_ssh_key  = file("~/.ssh/id_rsa")
}

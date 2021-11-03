
locals {
  network_clients = csvdecode(file("${path.module}/settings/network_clients.csv"))
}

module "unifi" {
  source = "./unifi"

  network_clients     = local.network_clients
  unifi_api_url       = var.unifi_api_url
  unifi_api_insecure  = var.unifi_api_insecure
  unifi_api_username  = var.unifi_api_username
  unifi_api_password  = var.unifi_api_password
  unifi_wlan_password = var.unifi_wlan_password
}

module "openwrt" {
  source = "./openwrt"

  network_clients = local.network_clients
  router_IP       = "192.168.2.1"
  router_ssh_key  = file("~/.ssh/id_rsa")
}

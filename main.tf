
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
  source = "./terraform/unifi"

  network_clients     = local.network_clients
  unifi_api_url       = data.sops_file.settings_secrets.data["unifi.api.url"]
  unifi_api_insecure  = data.sops_file.settings_secrets.data["unifi.api.insecure"]
  unifi_api_username  = data.sops_file.settings_secrets.data["unifi.api.username"]
  unifi_api_password  = data.sops_file.settings_secrets.data["unifi.api.password"]
  unifi_wlan_password = data.sops_file.settings_secrets.data["unifi.wlan.password"]
}

module "openwrt" {
  source = "./terraform/openwrt"

  network_clients = local.network_clients
  router_IP       = "192.168.2.1"
  router_ssh_key  = file("~/.ssh/id_rsa")
  dnsmasq_config_extra = nonsensitive(data.sops_file.settings_secrets.data["openwrt.dnsmasq_config_extra"])
}

module "authentik" {
  source = "./terraform/authentik"
  authentik_api_url      = data.sops_file.settings_secrets.data["authentik.api.url"]
  authentik_api_token    = data.sops_file.settings_secrets.data["authentik.api.token"]
  main_home_domain       = nonsensitive(data.sops_file.settings_secrets.data["main_home_domain"])
  authentik_ldap_base_dn = nonsensitive(data.sops_file.settings_secrets.data["authentik.ldap.base_dn"])
  authentik_users        = yamldecode(nonsensitive(data.sops_file.settings_secrets.raw)).authentik.users
  authentik_groups       = yamldecode(nonsensitive(data.sops_file.settings_secrets.raw)).authentik.groups
}

data "sops_file" "dnsmadeeasy" {
  source_file = "${path.module}/settings/dnsmadeeasy.yaml"
}
module "dnsmadeeasy" {
  source = "./terraform/dnsmadeeasy"
  api_key    = data.sops_file.dnsmadeeasy.data["credentials.api_key"]
  secret_key = data.sops_file.dnsmadeeasy.data["credentials.secret_key"]
  domains    = yamldecode(nonsensitive(data.sops_file.dnsmadeeasy.raw)).domains
  common     = yamldecode(nonsensitive(data.sops_file.dnsmadeeasy.raw)).common
}


terraform {
  required_providers {
    sops = {
      source = "carlpett/sops"
      version = "0.7.1"
    }
  }
}

data "sops_file" "network_clients" {
  source_file = "${path.module}/settings/network_clients.yaml"
}

data "sops_file" "settings_secrets" {
  source_file = "${path.module}/settings/secrets.yaml"
}

module "unifi" {
  source = "./terraform/unifi"

  network_clients     = yamldecode(nonsensitive(data.sops_file.network_clients.raw))
  unifi_api_url       = data.sops_file.settings_secrets.data["unifi.api.url"]
  unifi_api_insecure  = data.sops_file.settings_secrets.data["unifi.api.insecure"]
  unifi_api_username  = data.sops_file.settings_secrets.data["unifi.api.username"]
  unifi_api_password  = data.sops_file.settings_secrets.data["unifi.api.password"]
  unifi_wlan_password = data.sops_file.settings_secrets.data["unifi.wlan.password"]
}

# module "openwrt" {
#   source = "./terraform/openwrt"

#   network_clients = yamldecode(nonsensitive(data.sops_file.network_clients.raw))
#   router_IP       = "192.168.2.1"
#   router_ssh_key  = file("~/.ssh/id_rsa")
#   dnsmasq_config_extra = nonsensitive(data.sops_file.settings_secrets.data["openwrt.dnsmasq_config_extra"])
# }

data "sops_file" "authentik" {
  source_file = "${path.module}/settings/authentik.yaml"
}
module "authentik" {
  source = "./terraform/authentik"
  authentik_api_url      = data.sops_file.authentik.data["api.url"]
  authentik_api_token    = data.sops_file.authentik.data["api.token"]
  main_home_domain       = nonsensitive(data.sops_file.settings_secrets.data["main_home_domain"])
  authentik_users        = yamldecode(nonsensitive(data.sops_file.authentik.raw)).users
  authentik_groups       = yamldecode(nonsensitive(data.sops_file.authentik.raw)).groups
  authentik_config       = yamldecode(nonsensitive(data.sops_file.authentik.raw))
}

data "sops_file" "domains" {
  source_file = "${path.module}/settings/domains.yaml"
}
module "dnsmadeeasy" {
  source         = "./terraform/dnsmadeeasy"
  api_key        = data.sops_file.settings_secrets.data["dnsmadeeasy.credentials.api_key"]
  secret_key     = data.sops_file.settings_secrets.data["dnsmadeeasy.credentials.secret_key"]
  domains        = yamldecode(nonsensitive(data.sops_file.domains.raw)).domains
  domains_common = yamldecode(nonsensitive(data.sops_file.domains.raw)).common
}

data "sops_file" "vyos" {
  source_file = "${path.module}/settings/vyos.yaml"
}
module "vyos" {
  source = "./terraform/vyos"

  config    = yamldecode(nonsensitive(data.sops_file.vyos.raw))
  network_clients = yamldecode(nonsensitive(data.sops_file.network_clients.raw))
  domains        = yamldecode(nonsensitive(data.sops_file.domains.raw)).domains
  domains_common = yamldecode(nonsensitive(data.sops_file.domains.raw)).common
}

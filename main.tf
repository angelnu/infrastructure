
terraform {
  required_providers {
    sops = {
      source = "carlpett/sops"
      version = "0.7.0"
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

module "openwrt" {
  source = "./terraform/openwrt"

  network_clients = yamldecode(nonsensitive(data.sops_file.network_clients.raw))
  router_IP       = "192.168.2.1"
  router_ssh_key  = file("~/.ssh/id_rsa")
  dnsmasq_config_extra = nonsensitive(data.sops_file.settings_secrets.data["openwrt.dnsmasq_config_extra"])
}

data "sops_file" "authentik" {
  source_file = "${path.module}/settings/authentik.yaml"
}
module "authentik" {
  source = "./terraform/authentik"
  authentik_api_url      = data.sops_file.authentik.data["api.url"]
  authentik_api_token    = data.sops_file.authentik.data["api.token"]
  main_home_domain       = nonsensitive(data.sops_file.settings_secrets.data["main_home_domain"])
  authentik_ldap_base_dn = nonsensitive(data.sops_file.authentik.data["apps.ldap.base_dn"])
  gitea_client_secret    = data.sops_file.authentik.data["apps.gitea.client_secret"]
  authentik_users        = yamldecode(nonsensitive(data.sops_file.authentik.raw)).users
  authentik_groups       = yamldecode(nonsensitive(data.sops_file.authentik.raw)).groups
  authentik_config       = yamldecode(nonsensitive(data.sops_file.authentik.raw))
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

module "vyos" {
  source = "./terraform/vyos"

  config    = yamldecode(nonsensitive(data.sops_file.settings_secrets.raw)).vyos
  network_clients = yamldecode(nonsensitive(data.sops_file.network_clients.raw))

}

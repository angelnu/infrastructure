resource "vyos_config_block_tree" "vpn_wireguard" {
  path  = "interfaces wireguard ${var.config.wireguard.device}"
  count = (/*var.config.tunnel && */ length(var.config.wireguard.peers) > 0) ? 1 : 0

  configs = merge(
    {
      "private-key" = var.config.wireguard.PrivateKey,
      "port"        = var.config.wireguard.Port,
      //"address" = "192.168.60.1/24"
      "description" = "VPN-to-${var.config.wireguard.device}"
    },
    merge([
      for site_name, site in var.config.wireguard.peers : {

        # Common peer settings
        "peer ${site_name} allowed-ips" = site.AllowedIPs
        "peer ${site_name} public-key"  = site.PublicKey
      }
    ]...),
    merge([
      for site_name, site in var.config.wireguard.peers : {
        # PresharedKey
        "peer ${site_name} preshared-key" = site.PresharedKey
      } if contains(keys(site), "PresharedKey")
    ]...),
    merge([
      for site_name, site in var.config.wireguard.peers : {
        # persistent-keepalive
        "peer ${site_name} persistent-keepalive" = site.Keepalive
      } if contains(keys(site), "Keepalive")
    ]...),
    merge([
      for site_name, site in var.config.wireguard.peers : {

        # Location (currently only static IPs are supported so not used)
        "peer ${site_name} address" = site.Endpoint
        "peer ${site_name} port"    = site.Port
      } if contains(keys(site), "Endpoint")
    ]...),
  )
  depends_on = [
    vyos_config_block_tree.eth0
  ]
  timeouts {
    create  = "60m"
    delete  = "60m"
    update  = "60m"
    default = "60m"
  }
}


# (re-)set enpoint address from FQDN
resource "vyos_config_block_tree" "vpn_wireguard_cronjob" {
  for_each = { for k, v in var.config.wireguard.peers : k => v if contains(keys(v), "FQDN") }
  path     = "system task-scheduler task wireguard-FQDN-${each.key}"

  configs = {
    "interval"             = "1m",
    "executable path"      = "/usr/bin/wg",
    "executable arguments" = "set ${var.config.wireguard.device} peer ${each.value.PublicKey} endpoint $(dig +short @8.8.8.8 ${each.value.FQDN}):${each.value.Port}"
  }
  depends_on = [
    vyos_config_block_tree.vpn_wireguard
  ]
  timeouts {
    create  = "60m"
    delete  = "60m"
    update  = "60m"
    default = "60m"
  }
}
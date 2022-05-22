resource "vyos_config_block_tree" "vpn_wireguard" {
  path = "interfaces wireguard wg01"
  count = (/*var.config.tunnel && */ length(var.config.wireguard.peers) > 0 ) ? 1 : 0

  configs = merge(
    {
        "private-key" = var.config.wireguard.PrivateKey,
        "port" = var.config.wireguard.Port,
        //"address" = "192.168.0.2/18"
        "description" = "VPN-to-wg01"
    },
    merge([
        for site_name, site in var.config.wireguard.peers: {

            # Common peer settings
            "peer ${site_name} allowed-ips" = site.AllowedIPs
            "peer ${site_name} public-key" = site.PublicKey
            "peer ${site_name} preshared-key" = site.PresharedKey
        }
    ]...),
    merge([
        for site_name, site in var.config.wireguard.peers: {

            # Location (currently only static IPs are supported so not used)
            "peer ${site_name} address" = site.Endpoint
            "peer ${site_name} port" = site.Port
        } if contains(keys(site), "Endpoint")
    ]...),
  )
  depends_on = [
    vyos_config_block_tree.eth0
  ]
  timeouts {
    create = "60m"
    delete = "60m"
    update = "60m"
    default = "60m"
  }

}
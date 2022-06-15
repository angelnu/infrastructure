resource "vyos_config_block_tree" "static_routes" {
  path = "protocols static route"

  configs = merge(
    {
      # Default route
      "0.0.0.0/0 next-hop ${var.config.networks.fritzbox.nexthop} distance" = "1"    
      "0.0.0.0/0 next-hop ${var.config.networks.lte.nexthop} distance" = "10"
    },
    merge([
      # wireguard targets
      for site_name, site in var.config.wireguard.peers: {
          "${site.AllowedIPs} interface wg01" = ""
      }
    ]...),
    merge(flatten([
      # rules for ping targets for wan_loadbalance
      for entry in [var.config.networks.fritzbox,var.config.networks.lte] : [
        for id, target in entry.ping: {
            "${target}/32 next-hop ${entry.nexthop}" = ""
        }
      ]
    ])...),
  )
  depends_on = [
    vyos_config_block_tree.vpn_wireguard
  ]
  timeouts {
    create = "60m"
    delete = "60m"
    update = "60m"
    default = "60m"
  }

}

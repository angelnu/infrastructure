resource "vyos_config_block_tree" "static_routes" {
  path = "protocols static route"

  configs = merge(
    {
        # Default route
        "0.0.0.0/0 next-hop ${var.config.fritzbox.nexthop} distance" = "1"    
        "0.0.0.0/0 next-hop ${var.config.lte.nexthop} distance" = "10"
    },
    merge([
        # wireguard targets
        for site_name, site in var.config.wireguard.peers: {
            "${site.AllowedIPs} interface wg01" = ""
        }
    ]...),
    merge([
        # rules for ping targets for wan_loadbalance
        for entry in local.load_balance_wan_test_route_entries: {
            "${entry.target}/32 next-hop ${entry.nexthop}" = ""
        }
    ]...),
  )
  depends_on = [
    vyos_config_block_tree.vpn_wireguard
  ]
  timeouts {
    create = "60m"
    delete = "60m"
    update = "60m"
  }

}
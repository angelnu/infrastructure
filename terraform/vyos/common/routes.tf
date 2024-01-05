resource "vyos_config_block_tree" "static_routes" {
  path = "protocols static route"

  configs = merge({
      # Default route - fritzbox
      "0.0.0.0/0 next-hop ${var.config.networks.fritzbox.nexthop} distance" = "100"
      "0.0.0.0/0 next-hop ${var.config.networks.fritzbox.nexthop} interface" = var.config.networks.fritzbox.device
    },
    merge([
      # wireguard targets
      for site_name, site in var.config.wireguard.peers: {
          "${site.AllowedIPs} interface wg01" = ""
      }
    ]...),
    merge([
      # rules for ping targets for wan_loadbalance
      for ping in var.config.ping_test_ips : {

            "${ping}/32 next-hop ${var.config.networks.fritzbox.nexthop} distance" = "100"
            "${ping}/32 next-hop ${var.config.networks.fritzbox.nexthop} interface" = "${var.config.networks.fritzbox.device}${var.config.vrrp.nic_suffix}"

            "${replace(ping,"/\\d+$/", "0/24")} next-hop ${var.config.networks.fritzbox.nexthop} distance" = "100"
            "${replace(ping,"/\\d+$/", "0/24")} next-hop ${var.config.networks.fritzbox.nexthop} interface" = var.config.networks.fritzbox.device

            "${replace(ping,"/\\d+$/", "0/25")} next-hop ${var.config.networks.lte.nexthop} distance" = "100"
            "${replace(ping,"/\\d+$/", "0/25")} next-hop ${var.config.networks.lte.nexthop} interface" = var.config.networks.lte.device
            "${replace(ping,"/\\d+$/", "128/25")} next-hop ${var.config.networks.lte.nexthop} distance" = "100"
            "${replace(ping,"/\\d+$/", "128/25")} next-hop ${var.config.networks.lte.nexthop} interface" = var.config.networks.lte.device
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
    default = "60m"
  }

}

resource "vyos_config_block_tree" "failover_routes" {
  path = "protocols failover route"

  configs = merge(
    {
      # Default route - fritzbox VRP
      "0.0.0.0/1 next-hop ${var.config.networks.fritzbox.nexthop} metric" = "5"
      "0.0.0.0/1 next-hop ${var.config.networks.fritzbox.nexthop} interface" = "${var.config.networks.fritzbox.device}${var.config.vrrp.nic_suffix}"
      "0.0.0.0/1 next-hop ${var.config.networks.fritzbox.nexthop} check target" = jsonencode(var.config.ping_test_ips)
      "128.0.0.0/1 next-hop ${var.config.networks.fritzbox.nexthop} metric" = "5"
      "128.0.0.0/1 next-hop ${var.config.networks.fritzbox.nexthop} interface" = "${var.config.networks.fritzbox.device}${var.config.vrrp.nic_suffix}"
      "128.0.0.0/1 next-hop ${var.config.networks.fritzbox.nexthop} check target" = jsonencode(var.config.ping_test_ips)

      # Default route - fritzbox
      "0.0.0.0/0 next-hop ${var.config.networks.fritzbox.nexthop} metric" = "10"
      "0.0.0.0/0 next-hop ${var.config.networks.fritzbox.nexthop} interface" = var.config.networks.fritzbox.device
      "0.0.0.0/0 next-hop ${var.config.networks.fritzbox.nexthop} check target" = jsonencode(var.config.ping_test_ips)

      # Default route - lte
      "0.0.0.0/0 next-hop ${var.config.networks.lte.nexthop} metric" = "15"
      "0.0.0.0/0 next-hop ${var.config.networks.lte.nexthop} interface" = var.config.networks.lte.device
      "0.0.0.0/0 next-hop ${var.config.networks.lte.nexthop} check target" = jsonencode(var.config.ping_test_ips)
    },
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



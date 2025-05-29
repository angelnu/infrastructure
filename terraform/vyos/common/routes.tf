resource "vyos_config_block_tree" "static_routes" {
  path = "protocols static route"

  configs = merge(
    merge(
      # wireguard targets
      [for site_name, site in var.config.wireguard.peers :
        {
          "${site.AllowedIPs} interface wg01" = ""
        }
      ]
    ...),
    merge(
      # rules for ping targets for wan_loadbalance
      # They can be displayed with: show ip route
      [for ping in var.config.ping_test_ips :
        merge(
          [for network_name, network in var.config.networks :
            merge(
              [for device, destination in
                {
                  "${network.device}" = "${ping}/32"
                  # Make VRRP more specific so it gets prioriy by when routing
                  "${network.device}${network.vrrp.nic_suffix}" = "${replace(ping, "/\\d+$/", "0")}/24"
                } :
                {
                  "${destination} next-hop ${network.nexthop} distance"  = "100"
                  "${destination} next-hop ${network.nexthop} interface" = device
                }
              ]...
            ) if network.zone == "wan"
          ]...
      )]...
    ),
  )
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

resource "vyos_config_block_tree" "failover_routes" {
  path = "protocols failover route"

  configs = merge(
    # Default routes
    [for network_name, network in var.config.networks :
      merge(
        [for destination in [
          {
            address   = "0.0.0.0/0"
            metric    = 10 + network.priority # Room for up to 10 wan NICs as we should stay within [1-19] for the metric - it should be plenty :-)
            interface = network.device
          },
          {
            address   = "0.0.0.0/1" # Make VRRP more specific so it gets prioriy by when routing
            metric    = network.priority
            interface = "${network.device}${network.vrrp.nic_suffix}"
          },
          {
            address   = "128.0.0.0/1"
            metric    = network.priority
            interface = "${network.device}${network.vrrp.nic_suffix}"
          }
          ] : {
          "${destination.address} next-hop ${network.nexthop} metric"       = destination.metric
          "${destination.address} next-hop ${network.nexthop} interface"    = destination.interface
          "${destination.address} next-hop ${network.nexthop} check target" = jsonencode(var.config.ping_test_ips)

          }
        ]...
      ) if network.zone == "wan"
    ]...
  )
  timeouts {
    create  = "60m"
    delete  = "60m"
    update  = "60m"
    default = "60m"
  }

}



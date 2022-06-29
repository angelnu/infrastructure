resource "vyos_config_block_tree" "zone_policy" {
  
  path = "zone-policy"

  configs = merge(
    merge([      
      for zone in distinct([for network in var.config.networks: network.zone]):
      {
        "zone ${zone} interface"=jsonencode(concat(
          [for network in var.config.networks: network.device if network.zone == zone],
          [for nic in [var.config.wireguard.device]: nic if zone == "lan"]
        ))
      }
    ]...),
    {"zone lan from wan firewall name": "lan_from_wan"}
  )
  depends_on = [
    vyos_config_block_tree.firewall
  ]
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
    default = "60m"
  }
}
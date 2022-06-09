resource "vyos_config_block_tree" "load_balance_wan" {
  path = "load-balancing wan"
  configs = merge(
    {
      "interface-health ${var.config.fritzbox.device} nexthop" = var.config.fritzbox.nexthop
      "interface-health ${var.config.lte.device     } nexthop" = var.config.lte.nexthop
    },
    {
      for id, target in var.config.fritzbox.ping : "interface-health ${var.config.fritzbox.device} test ${id} target" => target
    },
    {
      for id, target in var.config.lte.ping      : "interface-health ${var.config.lte.device     } test ${id} target" => target
    },
    {
      # Exclude traffic to local networks
      "rule 5 exclude" = ""
      "rule 5 inbound-interface" = "eth+"
      "rule 5 destination address" = "192.168.0.0/16"
    },
    {
      # Exclude traffic to wireguard
      "rule 6 exclude" = ""
      "rule 6 inbound-interface" = var.config.wireguard.device
      "rule 6 destination address" = "192.168.0.0/16"
    },
    {
      # Load balance all the remaining traffic arriving via the lan
      "rule 10 inbound-interface"= var.config.lan.device,
      "rule 10 failover" = "",
      "rule 10 interface ${var.config.fritzbox.device} weight"= "10",
      "rule 10 interface ${var.config.lte.device} weight"= "1",
    },
    {
      # Load balance all the remaining traffic arriving via the wireguard
      "rule 11 inbound-interface"= var.config.wireguard.device,
      "rule 11 failover" = "",
      "rule 11 interface ${var.config.fritzbox.device} weight"= "10",
      "rule 11 interface ${var.config.lte.device} weight"= "1",
    },
    {
      "flush-connections" = "",
      //"enable-local-traffic" = "" It does not seem to do anything -> replace with static default rule bellow
    }

  )
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
    default = "60m"
  }
  depends_on = [
    vyos_config_block_tree.eth0,
    vyos_config_block_tree.eth1
  ]
}

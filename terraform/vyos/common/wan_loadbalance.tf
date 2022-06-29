resource "vyos_config_block_tree" "load_balance_wan" {
  path = "load-balancing wan"
  configs = merge(
    {
      "interface-health ${var.config.networks.fritzbox.device} nexthop" = var.config.networks.fritzbox.nexthop
      "interface-health ${var.config.networks.fritzbox.device} failure-count" = "1"
      "interface-health ${var.config.networks.fritzbox.device} success-count"    = "1"
      "interface-health ${var.config.networks.fritzbox.device} test 0 resp-time" = "5"
      "interface-health ${var.config.networks.fritzbox.device} test 0 ttl-limit" = "1"
      "interface-health ${var.config.networks.fritzbox.device} test 1 resp-time" = "5"
      "interface-health ${var.config.networks.fritzbox.device} test 1 ttl-limit" = "1"
      "interface-health ${var.config.networks.lte.device     } nexthop" = var.config.networks.lte.nexthop
      "interface-health ${var.config.networks.lte.device     } failure-count" = "1"
      "interface-health ${var.config.networks.lte.device     } success-count"    = "1"
      "interface-health ${var.config.networks.lte.device     } test 0 resp-time" = "5"
      "interface-health ${var.config.networks.lte.device     } test 0 ttl-limit" = "1"
      "interface-health ${var.config.networks.lte.device     } test 1 resp-time" = "5"
      "interface-health ${var.config.networks.lte.device     } test 1 ttl-limit" = "1"
    },
    {
      for id, target in var.config.networks.fritzbox.ping : "interface-health ${var.config.networks.fritzbox.device} test ${id} target" => target
    },
    {
      for id, target in var.config.networks.lte.ping      : "interface-health ${var.config.networks.lte.device     } test ${id} target" => target
    },
    {
      # Exclude traffic to local networks
      "rule 5 exclude"             = ""
      "rule 5 inbound-interface"   = "eth+"
      "rule 5 destination address" = "192.168.0.0/16"
      "rule 5 protocol"            = "all"
    },
    {
      # Exclude traffic to wireguard
      "rule 6 exclude"             = ""
      "rule 6 inbound-interface"   = var.config.wireguard.device
      "rule 6 destination address" = "192.168.0.0/16"
      "rule 6 protocol"            = "all"
    },
    {
      # Load balance all the remaining traffic arriving via the lan
      "rule 10 inbound-interface" = var.config.networks.lan.device,
      "rule 10 failover"          = "",
      "rule 10 interface ${var.config.networks.fritzbox.device} weight"= "10",
      "rule 10 interface ${var.config.networks.lte.device} weight"= "1",
      "rule 10 protocol"          = "all"
    },
    {
      # Load balance all the remaining traffic arriving via the wireguard
      "rule 11 inbound-interface" = var.config.wireguard.device,
      "rule 11 failover"          = "",
      "rule 11 interface ${var.config.networks.fritzbox.device} weight"= "10",
      "rule 11 interface ${var.config.networks.lte.device} weight"= "1",
      "rule 11 protocol"          = "all"
    },
    {
      "flush-connections" = "", #Problem with https://phabricator.vyos.net/T1311
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

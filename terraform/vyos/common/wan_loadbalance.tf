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
      "rule 10 inbound-interface"= var.config.lan.device,
      "rule 10 failover" = "",
      "rule 10 interface ${var.config.fritzbox.device} weight"= "10",
      "rule 10 interface ${var.config.lte.device} weight"= "1",
    },
    {
      "flush-connections" = "",
      //"enable-local-traffic" = "" It does not seem to do anything -> replace with static default rule bellow
    }

  )
  depends_on = [
    vyos_config_block_tree.eth0,
    vyos_config_block_tree.eth1
  ]
}

locals {
  load_balance_wan_test_route_entries = flatten([
    for entry in [var.config.fritzbox,var.config.lte] : [
      for id, target in entry.ping: {
        "target"  = target,
        "nexthop" = entry.nexthop
      }
    ]
  ])
}

// Static rules for ping targets
resource "vyos_config_block_tree" "load_balance_wan_test_route" {
  for_each = {
    for entry in local.load_balance_wan_test_route_entries : entry.target => entry.nexthop
  }
  path = "protocols static route ${each.key}/32"
  configs = {
    "next-hop ${each.value}" = ""
  }
}

// Default rute for local traffic
resource "vyos_config_block_tree" "load_balance_default_localhost" {
  path = "protocols static route 0.0.0.0/0"
  configs = {
    "next-hop ${var.config.fritzbox.nexthop} distance" = "1"    
    "next-hop ${var.config.lte.nexthop} distance" = "10"
  }
}
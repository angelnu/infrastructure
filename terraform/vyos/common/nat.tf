// LAN -> WAN
resource "vyos_config_block_tree" "nat_lan_to_wan" {
  for_each = {
      "100": var.config.fritzbox.device
      "110": var.config.lte.device
  }
  path = "nat source rule ${each.key}"

  configs = {
    "description" = "LAN -> WAN"
    "outbound-interface"= each.value,
    "source address"= var.config.lan.cidr,
    "translation address": "masquerade"
  }
  depends_on = [
    vyos_config_block_tree.eth0,
    vyos_config_block_tree.eth1
  ]
}

// PORT FORWARDING
locals {
  port_forwards_list = toset(flatten([
      for delta, inbound in {0:"fritzbox", 1:"lte"}: [
        for rule, values in var.config.port_forwards: merge({inbound=inbound, rule=rule+delta}, values)
      ]
  ]))
}

resource "vyos_config_block_tree" "nat_port_forwarding" {

  path = "nat destination rule"

  configs = merge(
    {
      # description
      for rule, entry in local.port_forwards_list : "${entry.rule} description" => "port forwarding ${entry.inbound}:${entry.port} to ${entry.address}"
    },
    {
      # destination port
      for rule, entry in local.port_forwards_list : "${entry.rule} destination port" => entry.port
    },
    {
      # inbound-interface
      for rule, entry in local.port_forwards_list : "${entry.rule} inbound-interface" => var.config[entry.inbound].device
    },
    {
      # protocol
      for rule, entry in local.port_forwards_list : "${entry.rule} protocol" => entry.protocol
    },
    {
      # translation address
      for rule, entry in local.port_forwards_list : "${entry.rule} translation address" => entry.address
    },
  )
  depends_on = [
    vyos_config_block_tree.eth0,
    vyos_config_block_tree.eth1
  ]
  timeouts {
    create = "60m"
    update = "50s"
    default = "50s"
  }
}

# [edit nat destination]
#  rule 200 {
#      description "Hairpin NAT for Home Assistant"
#      destination {
#          address <external IP/32>
#          port 8123
#      }
#      inbound-interface eth1 [This is my LAN Interface]
#      protocol tcp
#      translation {
#          address 192.168.0.7 [This is the Internal IP of my Home Assistant Instance]
#      }
#  }

# [edit nat source]
#  rule 200 {
#      description "Hairpin NAT for Home Assistant"
#      destination {
#          address 192.168.0.7
#          port 8123
#      }
#      outbound-interface eth1
#      protocol tcp
#      source {
#          address 192.168.0.0/16 [THIS IS IMPORTANT!!!!]
#      }
#      translation {
#          address masquerade
#      }
#  }
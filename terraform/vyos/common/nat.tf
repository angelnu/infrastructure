// LAN -> WAN
resource "vyos_config_block_tree" "nat_lan_to_wan" {
  for_each = {
      "10": var.config.fritzbox
      "11": var.config.lte
  }
  path = "nat source rule ${each.key}"

  configs = {
    "description" = "LAN -> WAN"
    "outbound-interface"= each.value.device,
    "source address"= var.config.lan.cidr,
    "destination address"= each.value.cidr,
    "translation address": "masquerade"
  }
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

// PORT FORWARDING
locals {
  port_forwards_list = toset(flatten([
      for delta, inbound in {0:"fritzbox", 1:"lte"}: [
        //Start at 100 so we have the range up to 100 available for other rules
        for rule, values in var.config.port_forwards: merge({inbound=inbound, rule=100+2*(rule)+delta}, values)
      ]
  ]))
}

resource "vyos_config_block_tree" "nat_destination_rules" {

  path = "nat destination"

  configs = merge([
      
        for rule, entry in local.port_forwards_list:
        {
          "rule ${entry.rule} description": "${entry.inbound} - ${entry.description}",
          "rule ${entry.rule} destination port": entry.port,
          "rule ${entry.rule} inbound-interface": var.config[entry.inbound].device,
          "rule ${entry.rule} protocol": entry.protocol
          "rule ${entry.rule} translation address": entry.address
          "rule ${entry.rule} translation port": contains(keys(entry), "translationPort") ? entry.translationPort: entry.port
        }
    ]...
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
// LAN -> WAN
resource "vyos_config_block_tree" "nat_source" {

  path = "nat source rule"

  configs = merge(
    # SNAT traffic to WAN (load balancer takes care of NATing traffic leaving the house)
    [ for outbound_index, outbound in
      flatten(
        [ for network_name, network in var.config.networks:
          [ for interface in
            [
              network.device,
              "${network.device}${network.vrrp.nic_suffix}"
            ]:
            {
              network_name: network_name
              network: network
              interface: interface
            }
          ] if network.zone == "wan"
        ]
      ):
      merge(
        [ for inbound_index, inbound in 
          concat(
            [ for network_name, network in var.config.networks:
              {
                network_name: network_name
                cidr: network.cidr
              } if network.zone == "lan"
            ],
            [
              {
                network_name: "Wireguard peers"
                cidr: var.config.wireguard.peers_cidr
              },
              {
                network_name: "Wireguard clients"
                cidr: var.config.wireguard.clients_cidr
              },
              {
                network_name: "Containers"
                cidr: var.config.containers.network.cidr
              }
            ]
          ):
          {
            # LAN -> WAN
            "${100 + 10*outbound_index + inbound_index} description" = "LAN (${inbound.network_name}) -> WAN (${outbound.network_name})"
            "${100 + 10*outbound_index + inbound_index} outbound-interface"= outbound.interface,
            "${100 + 10*outbound_index + inbound_index} destination address"= outbound.network.cidr,
            "${100 + 10*outbound_index + inbound_index} source address"= inbound.cidr,
            "${100 + 10*outbound_index + inbound_index} translation address": "masquerade"
          }
        ]...
      )
    ]...
  )
  depends_on = [
    vyos_config_block_tree.eth0,
    vyos_config_block_tree.eth1
  ]
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
    default = "60m"
  }
}

resource "vyos_config_block_tree" "nat_destination" {

  path = "nat destination"

  configs = merge(
    [ for inbound_index, inbound in
      flatten(
        [ for network_name, network in
          var.config.networks:
            [
              {
                name: network_name
                network: network
                interface: network.device
              },
              {
                name: "${network_name} (floating IP)"
                network: network
                interface: "${network.device}${network.vrrp.nic_suffix}"
              }
            ] if network.zone == "wan"
        ]
      ):
      merge(
        [ for rule_index, rule in var.config.port_forwards:
          {
            "rule ${100 + 10*rule_index+inbound_index} description": "${inbound.name} - ${rule.description}",
            "rule ${100 + 10*rule_index+inbound_index} destination port": rule.port,
            "rule ${100 + 10*rule_index+inbound_index} inbound-interface": inbound.interface,
            "rule ${100 + 10*rule_index+inbound_index} protocol": rule.protocol
            "rule ${100 + 10*rule_index+inbound_index} translation address": rule.address
            "rule ${100 + 10*rule_index+inbound_index} translation port": contains(keys(rule), "translationPort") ? rule.translationPort: rule.port
          }
        ]...
      )
    ]...
  )
  depends_on = [
    vyos_config_block_tree.eth0,
    vyos_config_block_tree.eth1
  ]
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
    default = "60m"
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
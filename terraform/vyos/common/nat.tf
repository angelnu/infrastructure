// LAN -> WAN
resource "vyos_config_block_tree" "nat_source" {

  path = "nat source rule"

  configs = merge([
      
      for delta, outbound in ["fritzbox", "lte"]: 
      {
        # LAN -> WAN
        "${100+delta} description" = "LAN -> WAN (${outbound})"
        "${100+delta} outbound-interface"= var.config.networks[outbound].device,
        "${100+delta} source address"= var.config.networks.lan.cidr,
        "${100+delta} destination address"= var.config.networks[outbound].cidr,
        "${100+delta} translation address": "masquerade"
        # Wireguard peers -> WAN
        "${102+delta} description" = "Wireguard peers-> WAN (${outbound})"
        "${102+delta} outbound-interface"= var.config.networks[outbound].device,
        "${102+delta} source address"= var.config.wireguard.peers_cidr
        "${102+delta} destination address"= var.config.networks[outbound].cidr,
        "${102+delta} translation address": "masquerade"
        # Wireguard clients -> WAN
        "${104+delta} description" = "Wireguard clients -> WAN (${outbound})"
        "${104+delta} outbound-interface"= var.config.networks[outbound].device,
        "${104+delta} source address"= var.config.wireguard.client_cidr
        "${104+delta} destination address"= var.config.networks[outbound].cidr,
        "${104+delta} translation address": "masquerade"
        # Block wireguard if not floating IP NIC is used
        # The WAN load balancer SNATs to the floating IP when available and if not
        # available we want to block the traffic to avoid confusing the remote peer.
        # This happens when the secondary VYOS is replaced by the primary after a reboot
        "${106+delta} description" = "block wireguard in ${outbound} "
        //"${106+delta} outbound-interface"= var.config.networks[outbound].device,
        "${106+delta} source address"= var.config.networks[outbound].router,
        "${106+delta} source port"= var.config.wireguard.Port
        "${106+delta} protocol"= "udp"
        #"${106+delta} translation address": "192.168.250.250"
        "${106+delta} translation address": "192.168.63.2"
        #"${106+delta} translation port": "52891"
      }
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

  configs = merge(flatten([
      
      for delta, inbound in ["fritzbox", "lte"]: [
        for index, rule in var.config.port_forwards:
        {
          "rule ${100+4*index+delta} description": "${inbound} - ${rule.description}",
          "rule ${100+4*index+delta} destination port": rule.port,
          "rule ${100+4*index+delta} inbound-interface": var.config.networks[inbound].device,
          "rule ${100+4*index+delta} protocol": rule.protocol
          "rule ${100+4*index+delta} translation address": rule.address
          "rule ${100+4*index+delta} translation port": contains(keys(rule), "translationPort") ? rule.translationPort: rule.port
          # load balancer
          "rule ${100+4*index+delta+2} description": "${inbound} (load balancer) - ${rule.description}",
          "rule ${100+4*index+delta+2} destination port": rule.port,
          "rule ${100+4*index+delta+2} inbound-interface": "${var.config.networks[inbound].device}${var.config.vrrp.nic_suffix}",
          "rule ${100+4*index+delta+2} protocol": rule.protocol
          "rule ${100+4*index+delta+2} translation address": rule.address
          "rule ${100+4*index+delta+2} translation port": contains(keys(rule), "translationPort") ? rule.translationPort: rule.port
        }
      ]
    ])...
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
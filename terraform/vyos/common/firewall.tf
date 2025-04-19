resource "vyos_config_block_tree" "firewall" {
  
  path = "firewall"

  configs = merge(
    # Define zones (lan, wan) and assign networks to them
    merge(
      [ for zone in
        distinct(
          # zones in networks
          [ for network in var.config.networks: network.zone]
        ):
        {
          "group interface-group IG_${zone} interface"=jsonencode(sort(concat(
            # main NIC
            [for network in var.config.networks: network.device if network.zone == zone],
            # floating IP NIC
            [for network_name, network in var.config.networks: "${var.config.networks[network_name].device}${var.config.networks[network_name].vrrp.nic_suffix}" if network.zone == zone],
            # Wireguard NIC (LAN)
            [for nic in [var.config.wireguard.device]: nic if zone == "lan"],
            # Podman NIC
            [for nic in [var.config.containers.network.nic]: nic if zone == "lan"],
          )))
        }
      ]...
    ),
    {
        #Allow pings to vyos
        "global-options all-ping": "enable" 

        # FORWARDING RULES

        #Forwarding drop by default
        "ipv4 forward filter default-action": "drop"

        # LAN -> LAN Accept
        "ipv4 forward filter rule 101 action"                            :"accept"
        "ipv4 forward filter rule 101 inbound-interface group" : "IG_lan"
        "ipv4 forward filter rule 101 outbound-interface group": "IG_lan"

        # WLAN - LAN jump
        "ipv4 forward filter rule 106 action"                             : "jump"
        "ipv4 forward filter rule 106 inbound-interface group"  : "IG_wan"
        "ipv4 forward filter rule 106 jump-target"                        : "lan_from_wan"
        "ipv4 forward filter rule 106 outbound-interface group" : "IG_lan"
        
        # WLAN -> WLAN accept
        "ipv4 forward filter rule 116 action"                             = "accept"
        "ipv4 forward filter rule 116 inbound-interface group"  = "IG_wan"
        "ipv4 forward filter rule 116 outbound-interface group" = "IG_wan"

        # WLAN -> LAN jump
        "ipv4 forward filter rule 121 action"                             = "jump"
        "ipv4 forward filter rule 121 inbound-interface group"  = "IG_lan"
        "ipv4 forward filter rule 121 jump-target"                        = "wan_from_lan"
        "ipv4 forward filter rule 121 outbound-interface group" = "IG_wan"
        
        # Settings for LAN -> WAN
        "ipv4 name wan_from_lan description" : "lan to wan"
        # - Accepty by default
        "ipv4 name wan_from_lan default-action" : "accept"
        
        # Settings for WAN -> LAN
        "ipv4 name lan_from_wan description" : "wan to lan"
        # - Drop by default
        "ipv4 name lan_from_wan default-action" : "drop"
        # - logging
        #"ipv4 name lan_from_wan enable-default-log" : ""
        # - Accept stablished TCP traffic
        "ipv4 name lan_from_wan rule 100 action": "accept"
        "ipv4 name lan_from_wan rule 100 state": "established"
        # - Accept related
        "ipv4 name lan_from_wan rule 101 action": "accept"
        "ipv4 name lan_from_wan rule 101 state": "related"
        #"ipv4 name lan_from_wan rule 101 log": "enable"
    },
    merge(
      [ for index, rule in var.config.port_forwards:
        {
          # - Open port
          "ipv4 name lan_from_wan rule ${10+index} description": rule.description
          "ipv4 name lan_from_wan rule ${10+index} action": "accept"
          "ipv4 name lan_from_wan rule ${10+index} destination port": contains(keys(rule), "translationPort") ? rule.translationPort: rule.port
          "ipv4 name lan_from_wan rule ${10+index} protocol": rule.protocol
            
        }
      ]...
    ),
    {
      # OUTPUT RULES        

      # Output traffic ok by default
      "ipv4 output filter default-action": "accept"
    },
    merge(
      [ for outbound_index, outbound in 
        [ for network_name, network in var.config.networks:
          {
            network: network
          } if network.zone == "wan"
        ]:
        {
          # #filter wireguard traffic not using VRRP
          "ipv4 output filter rule ${100 + outbound_index} source address" : outbound.network.router
          "ipv4 output filter rule ${100 + outbound_index} protocol" : "udp"
          "ipv4 output filter rule ${100 + outbound_index} source port" : var.config.wireguard.Port
          "ipv4 output filter rule ${100 + outbound_index} action" : "drop"
          # "ipv4 output filter rule ${100 + outbound_index} log" : "enable"
        }
      ]...
    ),
  )
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
    default = "60m"
  }
}
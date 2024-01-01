resource "vyos_config_block_tree" "firewall" {
  
  path = "firewall"

  configs = merge(
    # Define zones (lan, wan) and assign networks to them
    merge([      
      for zone in distinct([for network in var.config.networks: network.zone]):
      {
        "group interface-group IG_${zone} interface"=jsonencode(sort(concat(
          [for network in var.config.networks: network.device if network.zone == zone],
          [for nic in [var.config.wireguard.device]: nic if zone == "lan"],
          [for network_name, network in var.config.networks: "${var.config.networks[network_name].device}${var.config.vrrp.nic_suffix}" if network.zone == zone]
        )))
      }
    ]...),
    {
        #Allow pings to vyos
        "global-options all-ping": "enable"

        #Forwarding ok by default
        "ipv4 forward filter default-action": "drop"

        # LAN -> LAN Accept
        "ipv4 forward filter rule 101 action"                            :"accept"
        "ipv4 forward filter rule 101 inbound-interface interface-group" : "IG_lan"
        "ipv4 forward filter rule 101 outbound-interface interface-group": "IG_lan"

        # WLAN - LAN jump
        "ipv4 forward filter rule 106 action"                             : "jump"
        "ipv4 forward filter rule 106 inbound-interface interface-group"  : "IG_wan"
        "ipv4 forward filter rule 106 jump-target"                        : "lan_from_wan"
        "ipv4 forward filter rule 106 outbound-interface interface-group" : "IG_lan"
        
        # LAN Default drop
        "ipv4 forward filter rule 111 action"                             = "drop"
        "ipv4 forward filter rule 111 description"                        = "zone_lan default-action"
        "ipv4 forward filter rule 111 outbound-interface interface-group" = "IG_lan"
        
        # WLAN -> WLAN accept
        "ipv4 forward filter rule 116 action"                             = "accept"
        "ipv4 forward filter rule 116 inbound-interface interface-group"  = "IG_wan"
        "ipv4 forward filter rule 116 outbound-interface interface-group" = "IG_wan"

        # WLAN -> LAN jump
        "ipv4 forward filter rule 121 action"                             = "jump"
        "ipv4 forward filter rule 121 inbound-interface interface-group"  = "IG_lan"
        "ipv4 forward filter rule 121 jump-target"                        = "wan_from_lan"
        "ipv4 forward filter rule 121 outbound-interface interface-group" = "IG_wan"
        
        # WLAN Default drop
        "ipv4 forward filter rule 126 action"                             = "drop"
        "ipv4 forward filter rule 126 description"                        = "zone_wan default-action"
        "ipv4 forward filter rule 126 outbound-interface interface-group" = "IG_wan"
        
        # Settings for LAN -> WAN
        "ipv4 name wan_from_lan description" : "lan to wan"
        # - Drop by default
        "ipv4 name wan_from_lan default-action" : "accept"
        
        # Settings for WAN -> LAN
        "ipv4 name lan_from_wan description" : "wan to lan"
        # - Drop by default
        "ipv4 name lan_from_wan default-action" : "drop"
        # - logging
        #"ipv4 name lan_from_wan enable-default-log" : ""
        # - Accept stablished TCP traffic
        "ipv4 name lan_from_wan rule 100 action": "accept"
        "ipv4 name lan_from_wan rule 100 state established": "enable"
        # - Accept related
        "ipv4 name lan_from_wan rule 101 action": "accept"
        "ipv4 name lan_from_wan rule 101 state related": "enable"
        #"ipv4 name lan_from_wan rule 101 log": "enable"
    },
    merge([
      for index, rule in var.config.port_forwards:
      {
        # - Open port
        "ipv4 name lan_from_wan rule ${10+index} description": rule.description
        "ipv4 name lan_from_wan rule ${10+index} action": "accept"
        "ipv4 name lan_from_wan rule ${10+index} destination port": contains(keys(rule), "translationPort") ? rule.translationPort: rule.port
        "ipv4 name lan_from_wan rule ${10+index} protocol": rule.protocol
          
      }
    ]...)
  )
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
    default = "60m"
  }
}
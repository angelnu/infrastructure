resource "vyos_config_block_tree" "firewall" {
  
  path = "firewall"

  configs = merge(
    {
        #Allow pings to vyos
        "all-ping": "enable"
        
        # Settings for LAN -> WAN
        "name wan_from_lan description" : "lan to wan"
        # - Drop by default
        "name wan_from_lan default-action" : "accept"
        
        # Settings for WAN -> LAN
        "name lan_from_wan description" : "wan to lan"
        # - Drop by default
        "name lan_from_wan default-action" : "drop"
        # - logging
        #"name lan_from_wan enable-default-log" : ""
        # - Accept stablished TCP traffic
        "name lan_from_wan rule 100 action": "accept"
        "name lan_from_wan rule 100 state established": "enable"
        # - Accept related
        "name lan_from_wan rule 101 action": "accept"
        "name lan_from_wan rule 101 state related": "enable"
        #"name lan_from_wan rule 101 log": "enable"
    },
    merge([      
      for index, rule in var.config.port_forwards:
      {
        # - Open port
        "name lan_from_wan rule ${10+index} description": rule.description
        "name lan_from_wan rule ${10+index} action": "accept"
        "name lan_from_wan rule ${10+index} destination port": contains(keys(rule), "translationPort") ? rule.translationPort: rule.port
        "name lan_from_wan rule ${10+index} protocol": rule.protocol
          
      }
    ]...),    
    merge([      
      for zone in distinct([for network in var.config.networks: network.zone]):
      {
        "zone ${zone} interface"=jsonencode(sort(concat(
          [for network in var.config.networks: network.device if network.zone == zone],
          [for nic in [var.config.wireguard.device]: nic if zone == "lan"]
        )))
      }
    ]...),
    {
      "zone lan from wan firewall name": "lan_from_wan"
      "zone wan from lan firewall name": "wan_from_lan"
    }
  )
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
    default = "60m"
  }
}
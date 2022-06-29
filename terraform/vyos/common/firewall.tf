resource "vyos_config_block_tree" "firewall" {
  
  path = "firewall"

  configs = merge(
    {
        "all-ping": "enable"
        "name lan_from_wan default-action" : "drop"
        "name lan_from_wan enable-default-log" : ""
        "name lan_from_wan description" : "wan to lan"
        "name lan_from_wan rule 100 action": "accept"
        "name lan_from_wan rule 100 state established": "enable"
        "name lan_from_wan rule 101 action": "accept"
        "name lan_from_wan rule 101 log": "enable"
        "name lan_from_wan rule 101 state related": "enable"
    },
    merge([      
      for index, rule in var.config.port_forwards:
      {
        "name lan_from_wan rule ${10+index} description": rule.description
        "name lan_from_wan rule ${10+index} action": "accept"
        "name lan_from_wan rule ${10+index} destination port": contains(keys(rule), "translationPort") ? rule.translationPort: rule.port
        "name lan_from_wan rule ${10+index} protocol": rule.protocol
          
      }
    ]...),
  )
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
    default = "60m"
  }
}
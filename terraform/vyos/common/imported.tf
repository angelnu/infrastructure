/* NEEDS IMPORT: Run the following lines after installing vyos
terraform import module.vyos.vyos_config_block_tree.eth0 "interfaces ethernet eth0"
terraform import module.vyos.vyos_config.https_key "service https api keys id terraform key"
terraform import module.vyos.vyos_config.https_virtual_host "service https virtual-host rtr01 listen-address"
*/

resource "vyos_config_block_tree" "eth0" {
  path = "interfaces ethernet eth0"
  configs = {
    #"address"           = "dhcp"
    #"description"       = "API"
    "vif ${var.config.lan.vlan} address"     = var.config.lan.default_router_cidr
    "vif ${var.config.lan.vlan} description" = "lan"
    
    "vif ${var.config.lte.vlan} address"     = var.config.lte.default_router_cidr
    "vif ${var.config.lte.vlan} description" = "lte"
    "vif ${var.config.management.vlan} address"     = var.config.management.default_router_cidr
    "vif ${var.config.management.vlan} description" = "management"
  }
}

resource "vyos_config" "https_key" {
  key = "service https api keys id terraform key"
  value = sensitive(var.config.api.key)
}

resource "vyos_config" "https_virtual_host" {
  key = "service https virtual-host rtr01 listen-address"
  value = var.config.management.default_router
}

/* End of imported */
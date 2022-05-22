/* NEEDS IMPORT: Run the following lines after installing vyos
terraform import module.vyos.module.common_appliance.vyos_config_block_tree.eth0 "interfaces ethernet eth0"
terraform import module.vyos.module.common_appliance.vyos_config.https_key "service https api keys id terraform key"
terraform import module.vyos.module.common_appliance.vyos_config.https_virtual_host "service https virtual-host rtr01 listen-address"
*/

resource "vyos_config_block_tree" "eth0" {
  path = "interfaces ethernet eth0"
  configs = {
    "address"           = var.config.lan.router_cidr
    "description"       = "lan"
    #"vif ${var.config.lan.vlan} address"     = var.config.lan.router_cidr
    #"vif ${var.config.lan.vlan} description" = "lan"
    
    "vif ${var.config.lte.vlan} address"     = var.config.lte.router_cidr
    "vif ${var.config.lte.vlan} description" = "lte"
    "vif ${var.config.management.vlan} address"     = var.config.management.router_cidr
    "vif ${var.config.management.vlan} description" = "management"
  }
}

resource "vyos_config_block_tree" "http_api" {
  path = "service https"
  configs = {
    "api keys id terraform key"               = sensitive(var.config.api.key)
    "virtual-host rtr01 listen-address"       = var.config.management.router
    "virtual-host rtr01_lan listen-address"   = var.config.lan.router
  }
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
    default = "60m"
  }
}

/* End of imported */
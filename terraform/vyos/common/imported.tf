/* NEEDS IMPORT: Run the following lines after installing vyos
terraform import module.vyos.module.common_appliance.vyos_config_block_tree.eth0 "interfaces ethernet eth0"
terraform import module.vyos.module.common_appliance.vyos_config.https_key "service https api keys id terraform key"
terraform import module.vyos.module.common_appliance.vyos_config.https_virtual_host "service https virtual-host rtr01 listen-address"
*/

resource "vyos_config_block_tree" "eth0" {
  path = "interfaces ethernet eth0"
  configs = {
    "address"           = var.config.networks.lan.router_cidr
    "description"       = "lan"
    #"vif ${var.config.networks.lan.vlan} address"     = var.config.networks.lan.router_cidr
    #"vif ${var.config.networks.lan.vlan} description" = "lan"
    
    "vif ${var.config.networks.secondary.vlan} address"     = var.config.networks.secondary.router_cidr
    "vif ${var.config.networks.secondary.vlan} description" = "Secondary WAN"
    "vif ${var.config.networks.management.vlan} address"     = var.config.networks.management.router_cidr
    "vif ${var.config.networks.management.vlan} description" = "management"
    "vif ${var.config.networks.okd.vlan} address"     = var.config.networks.okd.router_cidr
    "vif ${var.config.networks.okd.vlan} description" = "okd"
  }
}

resource "vyos_config_block_tree" "http_api" {
  path = "service https"
  configs = {
    "api keys id terraform key" = sensitive(var.config.api.key)
    "listen-address"            = jsonencode([var.config.networks.management.router, var.config.networks.lan.router])
  }
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
    default = "60m"
  }
}

/* End of imported */
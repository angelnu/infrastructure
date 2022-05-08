/* NEEDS IMPORT: Run the following lines after installing vyos
terraform import module.vyos.vyos_config_block_tree.eth0 "interfaces ethernet eth0"
terraform import module.vyos.vyos_config.https_key "service https api keys id terraform key"
terraform import module.vyos.vyos_config.https_virtual_host "service https virtual-host rtr01 listen-address"
*/

resource "vyos_config_block_tree" "eth0" {
  path = "interfaces ethernet eth0"
  configs = {
    "address"           = "dhcp"
    "description"       = "API"
    "vif 7 address"     = var.config_global.common.lan.default_router_cidr
    "vif 7 description" = "lan"
    "vif 2 address"     = "dhcp"
    "vif 2 description" = "lte"
  }
}

resource "vyos_config" "https_key" {
  key = "service https api keys id terraform key"
  value = sensitive(var.config.api.key)
}

resource "vyos_config" "https_virtual_host" {
  key = "service https virtual-host rtr01 listen-address"
  value = "192.168.2.163"
}

/* End of imported */
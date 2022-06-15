resource "vyos_config_block_tree" "eth1" {
  path = "interfaces ethernet ${var.config.networks.fritzbox.device}"
  configs = {
    "address"           = var.config.networks.fritzbox.router_cidr
    "description"       = "fritzbox"
  }
}

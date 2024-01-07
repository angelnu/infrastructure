resource "vyos_config_block_tree" "eth1" {
  path = "interfaces ethernet ${var.config.networks.primary.device}"
  configs = {
    "address"           = var.config.networks.primary.router_cidr
    "description"       = "Primary WAN"
  }
}

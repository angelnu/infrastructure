resource "vyos_config_block_tree" "eth1" {
  path = "interfaces ethernet ${var.config.fritzbox.device}"
  configs = {
    "address"           = var.config.fritzbox.default_router_cidr
    "description"       = "fritzbox"
  }
}

resource "vyos_config_block_tree" "high_availability_lan" {
  path = "high-availability vrrp group lan"

  configs = {
    "vrid"      = var.config.lan.vrrp.vrid,
    "priority"  = var.config.lan.vrrp.priority,
    "interface" = var.config.lan.device,
    "address" = var.config.lan.dhcp.default_router_cidr
  }
  depends_on = [
    vyos_config_block_tree.eth0
  ]
}
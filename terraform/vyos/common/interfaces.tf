resource "vyos_config_block_tree" "eth1" {
  path = "interfaces ethernet ${var.config_global.common.fritzbox.device}"
  configs = {
    "address"           = "dhcp"
    "description"       = "fritbox"
  }
}

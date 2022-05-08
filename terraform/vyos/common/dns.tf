resource "vyos_config_block_tree" "dns" {
  path = "service dns forwarding"

  configs = {
    "cache-size"      = "0",
    "allow-from" = var.config_global.common.lan.cidr,
    "listen-address" = "0.0.0.0",
    "system" = ""
  }
  depends_on = [
    vyos_config_block_tree.eth0
  ]
}

resource "vyos_config" "system_name_server" {
  key = "system name-server"
  value = var.config_global.common.system.dns
}
resource "vyos_config_block_tree" "dhcp_server_lan" {
  path = "service dhcp-server shared-network-name lan subnet ${var.config_global.common.lan.cidr}"

  configs = merge(
    {
      "default-router" = var.config_global.common.lan.default_router,
      "domain-name" = "vyos.net",
      "lease" = "86400",
      "name-server"= var.config_global.common.lan.default_router
    },
    {
      for name, range in var.config_global.common.lan.dhcp.range : "range ${name} start" => range.start
    },
    {
      for name, range in var.config_global.common.lan.dhcp.range : "range ${name} stop" => range.stop
    }
  )
  depends_on = [
    vyos_config_block_tree.eth0
  ]
}
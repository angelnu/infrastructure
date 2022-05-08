resource "vyos_config_block_tree" "dhcp_server_lan" {
  path = "service dhcp-server shared-network-name lan subnet ${var.config.lan.cidr}"

  configs = merge(
    {
      "default-router" = var.config.lan.dhcp.default_router,
      "domain-name" = var.config.lan.dhcp.domain_name,
      "lease" = "86400",
      "name-server"= var.config.lan.dhcp.default_router
    },
    {
      for name, range in var.config.lan.dhcp.range : "range ${name} start" => range.start
    },
    {
      for name, range in var.config.lan.dhcp.range : "range ${name} stop" => range.stop
    }
  )
  depends_on = [
    vyos_config_block_tree.eth0
  ]
}
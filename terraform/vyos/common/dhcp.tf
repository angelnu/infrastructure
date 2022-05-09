resource "vyos_config_block_tree" "dhcp_server_lan" {
  path = "service dhcp-server"

  configs = merge(
    {
      "shared-network-name lan subnet ${var.config.lan.cidr} default-router" = var.config.lan.default_router,
      "shared-network-name lan subnet ${var.config.lan.cidr} domain-name" = var.config.lan.dhcp.domain_name,
      "shared-network-name lan subnet ${var.config.lan.cidr} lease" = "86400",
      "shared-network-name lan subnet ${var.config.lan.cidr} name-server"= var.config.lan.default_router
      "shared-network-name lan subnet ${var.config.lan.cidr} enable-failover"=""
    },
    {
      for name, range in var.config.lan.dhcp.range : "shared-network-name lan subnet ${var.config.lan.cidr} range ${name} start" => range.start
    },
    {
      for name, range in var.config.lan.dhcp.range : "shared-network-name lan subnet ${var.config.lan.cidr} range ${name} stop" => range.stop
    },
    {
      "failover source-address" = var.config.lan.router
      "failover name" = "lan"
      "failover remote" = var.config.lan.dhcp.failover.remote
      "failover status" = var.config.lan.dhcp.failover.status
    }
  )
  depends_on = [
    vyos_config_block_tree.eth0
  ]
}
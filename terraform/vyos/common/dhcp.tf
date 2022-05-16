resource "vyos_config_block_tree" "dhcp_server_lan" {
  path = "service dhcp-server"

  configs = merge(
    {
      # main setup
      "shared-network-name lan subnet ${var.config.lan.cidr} default-router" = var.config.lan.default_router,
      "shared-network-name lan subnet ${var.config.lan.cidr} domain-name" = var.config.lan.dhcp.domain_name,
      "shared-network-name lan subnet ${var.config.lan.cidr} lease" = "86400",
      "shared-network-name lan subnet ${var.config.lan.cidr} name-server"= var.config.lan.default_router
      "shared-network-name lan subnet ${var.config.lan.cidr} enable-failover"=""
    },
    {
      # ranges start
      for name, range in var.config.lan.dhcp.range : "shared-network-name lan subnet ${var.config.lan.cidr} range ${name} start" => range.start
    },
    {
      # ranges stop
      for name, range in var.config.lan.dhcp.range : "shared-network-name lan subnet ${var.config.lan.cidr} range ${name} stop" => range.stop
    },
    {
      "failover source-address" = var.config.lan.router
      "failover name" = "lan"
      "failover remote" = var.config.lan.dhcp.failover.remote
      "failover status" = var.config.lan.dhcp.failover.status
    },
    {
      # static allocation
      for host in local.host_by_name_with_mac : "shared-network-name lan subnet ${var.config.lan.cidr} static-mapping ${host.name} mac-address" => host.mac
    },
    {
      for host in local.host_by_name_with_mac : "shared-network-name lan subnet ${var.config.lan.cidr} static-mapping ${host.name} ip-address" => host.ip
    }
  )
  depends_on = [
    vyos_config_block_tree.eth0
  ]
  timeouts {
    create = "60m"
    update = "50s"
    default = "50s"
  }

}
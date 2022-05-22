resource "vyos_config_block_tree" "dhcp" {
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
    merge([
      # ranges
      for name, range in var.config.lan.dhcp.range : {
        "shared-network-name lan subnet ${var.config.lan.cidr} range ${name} start" = range.start
        "shared-network-name lan subnet ${var.config.lan.cidr} range ${name} stop" = range.stop
      }
    ]...),
    {
      "failover source-address" = var.config.lan.router
      "failover name" = "lan"
      "failover remote" = var.config.lan.dhcp.failover.remote
      "failover status" = var.config.lan.dhcp.failover.status
    },
    merge([
      # static allocation
      for host in local.host_by_name_with_mac : {
        "shared-network-name lan subnet ${var.config.lan.cidr} static-mapping ${host.name} mac-address" = host.mac
        "shared-network-name lan subnet ${var.config.lan.cidr} static-mapping ${host.name} ip-address" = host.ip
      }
    ]...),
  )
  depends_on = [
    vyos_config_block_tree.eth0
  ]
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
    default = "60m"
  }

}
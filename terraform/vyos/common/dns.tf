resource "vyos_config_block_tree" "dns" {
  path = "service dns forwarding"

  configs = {
    "cache-size"      = "0",
    "allow-from" = var.config.lan.cidr,
    "listen-address ${var.config.lan.default_router}" = "",
    "listen-address ${var.config.lan.router}" = "",
    "system" = ""
  }
  depends_on = [
    vyos_config_block_tree.eth0
  ]
}

resource "vyos_config" "system_name_server" {
  key = "system name-server"
  value = var.config.system.dns
}

resource "vyos_config_block_tree" "system_dns_static_host_mapping" {
  path = "system static-host-mapping"

  configs = merge(
    {
      # static allocation for hosts
      for host in local.host_by_name    : "host-name ${host.name}.${var.config.lan.dhcp.domain_name} inet" => host.ip
    },
    
    {
      # static allocation for domains
      for host in local.domains_by_name : "host-name ${host.name} inet" => host.ip
    }
  )
  timeouts {
    create  = "60m"
    update  = "60s"
    default = "60s"
  }

}
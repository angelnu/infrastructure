resource "vyos_config_block_tree" "dns" {
  path = "service dns forwarding"

  configs = {
    "cache-size"     = "200",
    "allow-from"     = jsonencode([var.config.networks.lan.cidr, var.config.wireguard.clients_cidr])
    "listen-address" = jsonencode([var.config.networks.lan.vrrp.ip, var.config.networks.lan.router])
    "system"         = ""
  }
  depends_on = [
    vyos_config_block_tree.eth0
  ]
}

resource "vyos_config_block_tree" "system_name_server" {
  path = "system name-server"
  configs = { "" : jsonencode(concat(
    [var.config.networks.lan.router], #This helps when primary DNS is not available as the DNS forward caches results
    var.config.system.dns
  )) }
}

resource "vyos_config_block_tree" "system_dns_static_host_mapping" {
  path = "system static-host-mapping"

  configs = merge(
    merge([
      for host in local.host_by_name : {
        # static allocation for hosts
        "host-name ${host.name}${length(split(".", host.name)) > 1 ? "" : ".${var.config.networks.lan.dhcp.domain_name}"} inet" = host.ip
      } #if !lookup(host, "is_dhcp", true) 
    ]...),
    merge(flatten([
      for domain in var.domains : [
        for record in concat(domain.records, var.domains_common.common_records) : {
          # static allocation for A Records
          "host-name ${record.name}${trimsuffix(record.name, ".") != record.name ? "" : ".${domain.url}"} inet" = record.value
        } if record.type == "A"
        && contains(keys(record), "value")
      ]
    ])...),
    merge(flatten([
      for domain in var.domains : [
        for record in concat(domain.records, var.domains_common.common_records) : {
          # static allocation for CNAME Records
          "host-name ${record.local_value}.${domain.url} alias" = "${record.name}${trimsuffix(record.name, ".") != record.name ? "" : ".${domain.url}"}"
        } if record.type == "CNAME"
        && contains(keys(record), "local_value")
      ]
    ])...),
  )
  timeouts {
    create  = "60m"
    update  = "60m"
    delete  = "60m"
    default = "60m"
  }

}
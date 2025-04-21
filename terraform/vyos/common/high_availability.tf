resource "vyos_config_block_tree" "high_availability_vrrp" {

  path = "high-availability vrrp"

  configs = merge(
    merge([
      for network_name in [for network_name, network in var.config.networks : network_name if contains(keys(network), "vrrp")] :
      {
        // group for interface
        "group ${network_name} vrid"                                                      = var.config.networks[network_name].vrrp.vrid
        "group ${network_name} priority"                                                  = var.config.vrrp.priority
        "group ${network_name} interface"                                                 = var.config.networks[network_name].device
        "group ${network_name} address ${var.config.networks[network_name].vrrp.ip_cidr}" = ""

        # Generate own NIC (if having two IPs in the same MAC is a problem)
        "group ${network_name} rfc3768-compatibility" = ""
      }
    ]...),

    {
      # Switch all interfaces floating IP together
      "sync-group MAIN member" = jsonencode([for network_name, network in var.config.networks : network_name if contains(keys(network), "vrrp")])
    }
  )
  depends_on = [
    vyos_config_block_tree.eth0
  ]
  timeouts {
    create  = "60m"
    update  = "60m"
    delete  = "60m"
    default = "60m"
  }
}

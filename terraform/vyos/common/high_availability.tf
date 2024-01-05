resource "vyos_config_block_tree" "high_availability_vrrp" {
  
  path = "high-availability vrrp"

  configs = merge(
     merge([      
      for delta, interface in ["lan", "fritzbox", "lte"]: 
      {
        // group for interface
        "group ${interface} vrid"      = var.config.vrrp.vrid+delta
        "group ${interface} priority"  = var.config.vrrp.priority
        "group ${interface} interface" = var.config.networks[interface].device
        "group ${interface} address ${var.config.networks[interface].floating_ip_cidr}" = ""
      }
    ]...),
   
    {
      # Switch all interfaces floating IP together
      "sync-group MAIN member" = jsonencode(["lan", "fritzbox", "lte"])

       # Generate own NIC (if having two IPs in the same MAC is a problem)
      "group fritzbox rfc3768-compatibility" = ""
    }
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

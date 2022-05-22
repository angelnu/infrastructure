resource "vyos_config_block_tree" "high_availability_vrrp" {
  
  path = "high-availability vrrp"

  configs = merge([      
      for interface in ["lan", "fritzbox", "lte"]: 
      {
        // group for interface
        "group ${interface} vrid"      = var.config.vrrp.vrid
        "group ${interface} priority"  = var.config.vrrp.priority
        "group ${interface} interface" = var.config[interface].device
        "group ${interface} address ${var.config[interface].default_router_cidr}" = ""

        // Switch all interfaces floating IP together
        "sync-group MAIN member" = interface
      }
    ]...
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



# resource "vyos_config" "high_availability_vrrp_main" {
#   for_each = toset(["lan", "fritzbox", "lte"])
#   key = "high-availability vrrp sync-group MAIN member"
#   value = each.value
# }
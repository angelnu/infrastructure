resource "vyos_config_block_tree" "high_availability_vrrp" {
  
  for_each = toset(["lan", "fritzbox", "lte"])
  path = "high-availability vrrp group ${each.value}"

  configs = {
    "vrid"      = var.config.vrrp.vrid,
    "priority"  = var.config.vrrp.priority,
    "interface" = var.config[each.value].device,
    "address ${var.config[each.value].default_router_cidr}" = ""
  }
  depends_on = [
    vyos_config_block_tree.eth0
  ]
}



# resource "vyos_config" "high_availability_vrrp_main" {
#   for_each = toset(["lan", "fritzbox", "lte"])
#   key = "high-availability vrrp sync-group MAIN member"
#   value = each.value
# }
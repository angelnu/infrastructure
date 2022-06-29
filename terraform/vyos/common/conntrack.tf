# NOTE: it is very important to delete the contrack modules or the API refresh will fail
# 
# delete system conntrack modules

# DISABLED until https://phabricator.vyos.net/T1311 is fixed

# resource "vyos_config_block_tree" "service_conntrack_sync" {
  
#   path = "service conntrack-sync"

#   configs = {
#     // group for interface
#     "accept-protocol"      = jsonencode(["udp", "icmp", "tcp"])
#     "failover-mechanism vrrp sync-group" = "MAIN"
#     "interface ${var.config.networks.lan.device}" = ""
#     "mcast-group" = "224.0.0.50"
#     }
#   depends_on = [
#     vyos_config_block_tree.high_availability_vrrp
#   ]
#   timeouts {
#     create = "60m"
#     update = "60m"
#     delete = "60m"
#     default = "60m"
#   }
# }

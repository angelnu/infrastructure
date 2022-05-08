# resource "vyos_config_block_tree" "nat" {
#   path = "nat source rule 100"

#   configs = {
#     "outbound-interface"= var.config.fritzbox.device,
#     "source address"= var.config.lan.cidr,
#     "translation address": "masquerade"
#   }
#   depends_on = [
#     vyos_config_block_tree.eth0,
#     vyos_config_block_tree.eth1
#   ]
# }

# resource "vyos_config_block_tree" "nat_s" {
#   path = "nat source rule 200"

#   configs = {
#     "outbound-interface"= var.config.lte.device,
#     "source address"= var.config.lan.cidr,
#     "translation address": "masquerade"
#   }
#   depends_on = [
#     vyos_config_block_tree.eth0,
#     vyos_config_block_tree.eth1
#   ]
# }
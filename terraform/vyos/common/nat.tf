# resource "vyos_config_block_tree" "nat" {
#   path = "nat source rule 100"

#   configs = {
#     "outbound-interface"= "eth0.3",
#     "source address"= "192.168.200.0/24",
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
#     "outbound-interface"= "eth0.2",
#     "source address"= "192.168.200.0/24",
#     "translation address": "masquerade"
#   }
#   depends_on = [
#     vyos_config_block_tree.eth0,
#     vyos_config_block_tree.eth1
#   ]
# }
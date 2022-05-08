resource "vyos_config" "wan_primary" {
  key = "load-balancing wan interface-health ${var.config_global.common.fritzbox.device} nexthop"
  value = "dhcp"
  depends_on = [
    vyos_config_block_tree.eth0,
    vyos_config_block_tree.eth1
  ]
}

resource "vyos_config" "wan_primary_0" {
  key = "load-balancing wan interface-health ${var.config_global.common.fritzbox.device} test 0 target"
  value = "1.1.1.1"
  depends_on = [
    vyos_config.wan_primary
  ]
}

resource "vyos_config" "wan_primary_1" {
  key = "load-balancing wan interface-health ${var.config_global.common.fritzbox.device} test 1 target"
  value = "google.de"
  depends_on = [
    vyos_config.wan_primary
  ]
}

resource "vyos_config" "wan_secondary" {
  key = "load-balancing wan interface-health ${var.config_global.common.lte.device} nexthop"
  value = "dhcp"
  depends_on = [
    vyos_config_block_tree.eth0,
    vyos_config_block_tree.eth1
  ]
}
resource "vyos_config" "wan_secondary_0" {
  key = "load-balancing wan interface-health ${var.config_global.common.lte.device} test 0 target"
  value = "1.1.1.1"
  depends_on = [
    vyos_config.wan_secondary,
  ]
}

resource "vyos_config" "wan_secondary_1" {
  key = "load-balancing wan interface-health ${var.config_global.common.lte.device} test 1 target"
  value = "google.de"
  depends_on = [
    vyos_config.wan_secondary,
  ]
}

resource "vyos_config_block_tree" "wan_rule_1" {
  path = "load-balancing wan rule 1"

  configs = {
    "inbound-interface"= var.config_global.common.lan.device,
    "failover" = "",
    "interface ${var.config_global.common.fritzbox.device} weight"= "2",
    "interface ${var.config_global.common.lte.device} weight"= "1",
  }
  depends_on = [
    vyos_config.wan_primary,
    vyos_config.wan_secondary,
  ]
}

resource "vyos_config" "wan_flush" {
  key = "load-balancing wan flush-connections"
  value = ""
  depends_on = [
    vyos_config_block_tree.wan_rule_1
  ]
}
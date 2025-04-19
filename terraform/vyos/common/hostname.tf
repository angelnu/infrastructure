resource "vyos_config_block_tree" "hostname" {
  path = "system host-name"

  configs = {
    "" = var.config.hostname,
  }
  depends_on = [
    vyos_config_block_tree.eth0
  ]
}
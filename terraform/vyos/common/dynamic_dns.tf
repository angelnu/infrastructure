resource "vyos_config_block_tree" "dynamic_dns" {
  path = "service dns dynamic name dnsmadeeasy"

  configs = {
    protocol      = var.config.dynamic_dns.protocol
    username      = var.config.dynamic_dns.username
    password      = var.config.dynamic_dns.password
    "host-name"   = var.config.dynamic_dns.hostname
    "address web url" = "https://ip.dnshome.de"
  }
  depends_on = [
    vyos_config_block_tree.eth0
  ]
}

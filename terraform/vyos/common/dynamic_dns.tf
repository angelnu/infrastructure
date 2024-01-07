resource "vyos_config_block_tree" "dynamic_dns" {
  path = "service dns dynamic address web service dnsmadeeasy"

  configs = {
    protocol      = var.config.dynamic_dns.protocol
    username      = var.config.dynamic_dns.username
    password      = var.config.dynamic_dns.password
    "host-name"   = var.config.dynamic_dns.hostname
  }
  depends_on = [
    vyos_config_block_tree.eth0
  ]
}

resource "vyos_config_block_tree" "dynamic_dns_web_options" {
  path = "service dns dynamic address web web-options"

  configs = {
    url      = "https://ip.dnshome.de"
  }
  depends_on = [
    vyos_config_block_tree.eth0
  ]
}
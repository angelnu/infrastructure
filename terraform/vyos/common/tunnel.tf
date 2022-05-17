resource "vyos_config_block_tree" "vpnl_ipsec" {
  path = "vpn ipsec"
  //count = var.config.tunnel ? 1 : 0

  configs = merge(
    merge([
        for site in var.config.site_to_site: {

            # IKE group
            "ike-group ${site.remote}-ike ikev2-reauth"="no",
            "ike-group ${site.remote}-ike key-exchange"="ikev1",
            "ike-group ${site.remote}-ike mode"="aggressive",
            "ike-group ${site.remote}-ike lifetime"="3600",
            "ike-group ${site.remote}-ike proposal 1 encryption"="aes256",
            "ike-group ${site.remote}-ike proposal 1 hash"="sha1",

            # ESP group
            "esp-group ${site.remote}-esp compression"= "disable",
            "esp-group ${site.remote}-esp lifetime"=3600,
            "esp-group ${site.remote}-esp mode"="tunnel",
            "esp-group ${site.remote}-esp pfs"="enable",
            "esp-group ${site.remote}-esp proposal 1 encryption"="aes256",
            "esp-group ${site.remote}-esp proposal 1 hash"="sha1",

            # Tunnel
            "site-to-site peer ${site.exposed?"":"%"}${site.remote} authentication mode"="pre-shared-secret",
            "site-to-site peer ${site.exposed?"":"%"}${site.remote} authentication pre-shared-secret"=sensitive(site.pre-shared-secret),
            "site-to-site peer ${site.exposed?"":"%"}${site.remote} authentication id"="@casa96.angelnu.com",
            "site-to-site peer ${site.exposed?"":"%"}${site.remote} authentication remote-id"="@${site.remote}",
            "site-to-site peer ${site.exposed?"":"%"}${site.remote} ike-group"="${site.remote}-ike",
            "site-to-site peer ${site.exposed?"":"%"}${site.remote} local-address"=var.config.fritzbox.default_router,
            "site-to-site peer ${site.exposed?"":"%"}${site.remote} connection-type"=site.exposed ? "initiate" : "respond"
            //"site-to-site peer ${site.exposed?"":"%"}${site.remote} tunnel 0 allow-nat-networks"="disable",
            //"site-to-site peer ${site.exposed?"":"%"}${site.remote} tunnel 0 allow-public-networks"="disable",
            "site-to-site peer ${site.exposed?"":"%"}${site.remote} tunnel 0 esp-group"="${site.remote}-esp",
            "site-to-site peer ${site.exposed?"":"%"}${site.remote} tunnel 0 local prefix"=var.config.lan.cidr,
            "site-to-site peer ${site.exposed?"":"%"}${site.remote} tunnel 0 remote prefix"=site.cidr,
        }
    ]...),
    merge([
        for site in var.config.site_to_site: {
            # detection and recovery for exposed sites
            "ike-group ${site.remote}-ike close-action"="restart"
            "ike-group ${site.remote}-ike dead-peer-detection action"="restart"
            "ike-group ${site.remote}-ike dead-peer-detection interval"="30"
            "ike-group ${site.remote}-ike dead-peer-detection timeout"="120"

            "interface"=var.config.fritzbox.device,
        } if site.exposed
    ]...),
  )
  depends_on = [
    vyos_config_block_tree.eth0
  ]
  timeouts {
    create = "60m"
    update = "50s"
    default = "50s"
  }

}
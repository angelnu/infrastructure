resource "vyos_config_block_tree" "ipsec" {
  path  = "vpn ipsec"
  count = (var.config.ipsec.enabled && length(var.config.ipsec.peers) > 0) ? 1 : 0

  configs = merge(
    merge([
      for site in var.config.site_to_site : {

        # IKE group
        "ike-group ${site.remote}-ike ikev2-reauth" = "no",
        "ike-group ${site.remote}-ike key-exchange" = "ikev1",
        "ike-group ${site.remote}-ike mode"         = "aggressive",
        "ike-group ${site.remote}-ike lifetime"     = "3600",
        #"ike-group ${site.remote}-ike proposal 1 encryption"="aes256",
        "ike-group ${site.remote}-ike proposal 1 encryption" = "aes192",
        "ike-group ${site.remote}-ike proposal 1 hash"       = "sha1",
        "ike-group ${site.remote}-ike proposal 1 dh-group"   = "2",

        # ESP group
        "esp-group ${site.remote}-esp compression"           = "disable",
        "esp-group ${site.remote}-esp lifetime"              = 3600,
        "esp-group ${site.remote}-esp mode"                  = "tunnel",
        "esp-group ${site.remote}-esp pfs"                   = "dh-group2",
        "esp-group ${site.remote}-esp proposal 1 encryption" = "aes192",
        "esp-group ${site.remote}-esp proposal 1 hash"       = "sha1",
        //"esp-group ${site.remote}-esp proposal 1 dh-group"="2",

        # Tunnel
        "site-to-site peer ${site.exposed ? site.remote : "31.4.242.182"} authentication mode"              = "pre-shared-secret",
        "site-to-site peer ${site.exposed ? site.remote : "31.4.242.182"} authentication pre-shared-secret" = sensitive(site.pre-shared-secret),
        "site-to-site peer ${site.exposed ? site.remote : "31.4.242.182"} authentication id"                = "@casa96.angelnu.com",
        "site-to-site peer ${site.exposed ? site.remote : "31.4.242.182"} authentication remote-id"         = "${site.exposed ? "@" : "@"}${site.remote}",
        "site-to-site peer ${site.exposed ? site.remote : "31.4.242.182"} ike-group"                        = "${site.remote}-ike",
        "site-to-site peer ${site.exposed ? site.remote : "31.4.242.182"} local-address"                    = var.config.networks.primary.default_router,

        "site-to-site peer ${site.exposed ? site.remote : "31.4.242.182"} connection-type" = site.exposed ? "initiate" : "respond"

        //"site-to-site peer ${site.exposed?site.remote:"31.4.242.182"} tunnel 0 allow-nat-networks"="disable",
        //"site-to-site peer ${site.exposed?site.remote:"31.4.242.182"} tunnel 0 allow-public-networks"="disable",
        "site-to-site peer ${site.exposed ? site.remote : "31.4.242.182"} tunnel 0 esp-group"     = "${site.remote}-esp",
        "site-to-site peer ${site.exposed ? site.remote : "31.4.242.182"} tunnel 0 local prefix"  = var.config.networks.lan.cidr,
        "site-to-site peer ${site.exposed ? site.remote : "31.4.242.182"} tunnel 0 remote prefix" = site.cidr,
      }
    ]...),
    merge([
      for site in var.config.site_to_site : {
        # detection and recovery for exposed sites
        "ike-group ${site.remote}-ike close-action"                 = "restart"
        "ike-group ${site.remote}-ike dead-peer-detection action"   = "restart"
        "ike-group ${site.remote}-ike dead-peer-detection interval" = "30"
        "ike-group ${site.remote}-ike dead-peer-detection timeout"  = "120"

        "interface" = var.config.networks.primary.device,
      } if site.exposed
    ]...),
  )
  depends_on = [
    vyos_config_block_tree.eth0
  ]
  timeouts {
    create  = "60m"
    delete  = "60m"
    update  = "60m"
    default = "60m"
  }

}

# Edit /usr/share/vyos/templates/ipsec/charon.tmpl:
#    # Allow IKEv1 Aggressive Mode with pre-shared keys as responder.
#    i_dont_care_about_security_and_use_aggressive_mode_psk = yes
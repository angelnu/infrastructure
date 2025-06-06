resource "unifi_network" "lte" {
  dhcp_dns            = []
  dhcp_enabled        = false
  dhcp_lease          = 86400
  dhcp_relay_enabled  = false
  dhcpd_boot_enabled  = false
  domain_name         = "lte"
  igmp_snooping       = false
  ipv6_interface_type = "none"
  ipv6_ra_enable      = true
  name                = "lte"
  network_group       = "LAN"
  purpose             = "vlan-only"
  site                = "default"
  subnet              = "192.168.62.0/24"
  vlan_id             = 2
  wan_dns             = []
  wan_egress_qos      = 0
}

resource "unifi_network" "fritzbox" {
  dhcp_dns           = []
  dhcp_enabled       = false
  dhcp_lease         = 86400
  dhcp_relay_enabled = false
  dhcpd_boot_enabled = false
  #domain_name         = "fritzbox"
  igmp_snooping       = false
  ipv6_interface_type = "none"
  ipv6_ra_enable      = false
  name                = "fritzbox"
  network_group       = "LAN"
  purpose             = "corporate"
  site                = "default"
  subnet              = "192.168.63.0/24"
  vlan_id             = 3
  wan_dns             = []
  wan_egress_qos      = 0
}

data "unifi_network" "LAN" {
  name = "Default"
}

resource "unifi_network" "management" {
  dhcp_dns            = []
  dhcp_enabled        = false
  dhcpd_boot_enabled  = false
  igmp_snooping       = false
  ipv6_ra_enable      = false
  name                = "management"
  network_group       = "LAN"
  purpose             = "vlan-only"
  site                = "default"
  subnet              = "192.168.250.0/24"
  vlan_id             = 250
  wan_dns             = []
  wan_egress_qos      = 0
}

resource "unifi_network" "okd" {
  dhcp_dns            = []
  dhcp_enabled        = false
  dhcpd_boot_enabled  = false
  igmp_snooping       = false
  ipv6_ra_enable      = false
  name                = "okd"
  network_group       = "LAN"
  purpose             = "vlan-only"
  site                = "default"
  subnet              = "192.168.251.0/24"
  vlan_id             = 251
  wan_dns             = []
  wan_egress_qos      = 0
}

resource "unifi_network" "pueblo_modem" {
  dhcp_dns            = []
  dhcp_enabled        = false
  dhcp_lease          = 86400
  dhcp_relay_enabled  = false
  dhcp_start          = "192.168.254.6"
  dhcp_stop           = "192.168.254.254"
  dhcpd_boot_enabled  = false
  domain_name         = "localdomain"
  igmp_snooping       = false
  ipv6_interface_type = "none"
  ipv6_ra_enable      = false
  name                = "pueblo-modem"
  network_group       = "LAN"
  purpose             = "corporate"
  site                = "default"
  subnet              = "192.168.254.0/24"
  vlan_id             = 6
  wan_dns             = []
  wan_egress_qos      = 0
}
resource "unifi_network" "lte" {
  dhcp_enabled       = false
  dhcp_lease         = 86400
  dhcp_relay_enabled = false
  dhcpd_boot_enabled = false
  #domain_name         = "lte"
  name          = "lte"
  network_group = "LAN"
  purpose       = "vlan-only"
  site          = "default"
  subnet        = "192.168.62.1/24"
  vlan_id       = 2
}

resource "unifi_network" "fritzbox" {
  dhcp_enabled       = false
  dhcp_lease         = 86400
  dhcp_relay_enabled = false
  dhcpd_boot_enabled = false
  #domain_name         = "fritzbox"
  name          = "fritzbox"
  network_group = "LAN"
  purpose       = "corporate"
  site          = "default"
  subnet        = "192.168.63.1/24"
  vlan_id       = 3
}

data "unifi_network" "LAN" {
  name = "Default"
}

resource "unifi_network" "management" {
  dhcp_enabled       = false
  dhcp_relay_enabled = false
  dhcpd_boot_enabled = false
  name               = "management"
  network_group      = "LAN"
  purpose            = "vlan-only"
  site               = "default"
  subnet             = "192.168.250.1/24"
  vlan_id            = 250
}

resource "unifi_network" "okd" {
  dhcp_enabled       = false
  dhcp_relay_enabled = false
  dhcpd_boot_enabled = false
  name               = "okd"
  network_group      = "LAN"
  purpose            = "vlan-only"
  site               = "default"
  subnet             = "192.168.251.1/24"
  vlan_id            = 251
}

resource "unifi_network" "pueblo_modem" {
  dhcp_enabled       = false
  dhcp_lease         = 86400
  dhcp_relay_enabled = false
  dhcp_start         = "192.168.254.6"
  dhcp_stop          = "192.168.254.254"
  dhcpd_boot_enabled = false
  name               = "pueblo-modem"
  network_group      = "LAN"
  purpose            = "corporate"
  site               = "default"
  subnet             = "192.168.254.1/24"
  vlan_id            = 6
}

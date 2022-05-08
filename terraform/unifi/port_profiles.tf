data "unifi_port_profile" "all" {
}

data  "unifi_port_profile" "disabled" {
}

data "unifi_port_profile" "lan" {
    name= "LAN"
}

data "unifi_port_profile" "lte" {
    name= "lte"
}

data "unifi_port_profile" "fritzbox" {
    name= "fritzbox"
}

resource "unifi_port_profile" "off" {
    name = "Off"
    autoneg = false
    dot1x_idle_timeout = 0
    forward = "disabled"
    lldpmed_enabled = false
    stp_port_mode = false
    poe_mode = "off"
}
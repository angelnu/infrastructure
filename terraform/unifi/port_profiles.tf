

resource "unifi_port_profile" "off" {
    name = "Off"
    autoneg = false
    dot1x_idle_timeout = 0
    forward = "disabled"
    lldpmed_enabled = false
    stp_port_mode = false
    poe_mode = "off"
    egress_rate_limit_kbps = 100
    stormctrl_bcast_rate = 100
    stormctrl_mcast_rate = 100
    stormctrl_ucast_rate = 100
}
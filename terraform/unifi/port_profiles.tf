

resource "unifi_port_profile" "off" {
  name                   = "Off"
  poe_mode               = "off"
  forward                = "customize"
  speed                  = 10
  lldpmed_notify_enabled = false
}

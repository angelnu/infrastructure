resource "unifi_device" "switch_kitchen" {
  mac  = "24:5a:4c:53:1b:db"
  name = "Switch Kitchen"
  site = "default"
  port_override {
    name   = "Homematic AP"
    number = 1
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "Homematic GW"
    number = 6
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "LTE Router"
    number = 7
    #port_profile_id = data.unifi_port_profile.lte.id
  }
  port_override {
    name   = "Switch Long Corridor"
    number = 8
    #port_profile_id = data.unifi_port_profile.all.id
  }
}

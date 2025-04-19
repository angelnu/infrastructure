resource "unifi_device" "switch_alicia" {
  mac  = "74:ac:b9:ae:76:a5"
  name = "Switch Alicia"
  site = "default"

  port_override {
    name   = "Switch Livingroom"
    number = 1
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "Switch Corridor"
    number = 2
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "Switch Workroom"
    number = 3
    #port_profile_id = data.unifi_port_profile.all.id
  }
}

resource "unifi_device" "switch_pueblo_buardilla" {
  mac  = "d0:21:f9:de:ac:ab"
  name = "Pueblo Switch Buardilla"
  site = "default"
  port_override {
    name   = "Modem"
    number = 7
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "Fritbox WAN"
    number = 9
    #port_profile_id = data.unifi_port_profile.all.id
  }
  # port_override {
  #     name            = "AP Guestroom"
  #     number          = 3
  #     #port_profile_id = data.unifi_port_profile.all.id
  # }
  # port_override {
  #     name            = "Chromecast Ultra"
  #     number          = 4
  #     #port_profile_id = data.unifi_port_profile.all.id
  # }
  # port_override {
  #     name            = "Homematic Gateway"
  #     number          = 6
  #     #port_profile_id = data.unifi_port_profile.all.id
  # }
  # port_override {
  #     name            = "Dragino AP"
  #     number          = 7
  #     #port_profile_id = data.unifi_port_profile.all.id
  # }
  # port_override {
  #     name            = "Switch Workroom"
  #     number          = 8
  #     #port_profile_id = data.unifi_port_profile.all.id
  # }
}
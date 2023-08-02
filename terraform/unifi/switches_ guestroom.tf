resource "unifi_device" "switch_e_guestroom" {
    mac      = "70:a7:41:e5:6b:ce"
    name     = "Switch E Guestroom"
    site     = "default"
    port_override {
        name            = "TBD"
        number          = 1
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "TBD"
        number          = 2
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "TBD"
        number          = 3
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "TBD"
        number          = 4
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "TBD"
        number          = 6
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "TBD"
        number          = 7
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "TBD"
        number          = 8
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "TBD"
        number          = 9
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "TBD"
        number          = 10
        #port_profile_id = data.unifi_port_profile.all.id
    }
}



resource "unifi_device" "switch_guestroom_door" {
    mac      = "68:d7:9a:4f:0f:71"
    name     = "Switch Guestroom Door"
    site     = "default"
    port_override {
      name            = "Switch Guestroom"
      number          = 1
      #port_profile_id = data.unifi_port_profile.all.id
    }
}



resource "unifi_device" "switch_guestroom_pc" {
    mac      = "68:d7:9a:4f:0f:b7"
    name     = "Switch Guestroom PC"
    site     = "default"
    port_override {
      name            = "Switch Guestroom"
      number          = 1
      #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
      name            = "Desktop PC"
      number          = 2
      #port_profile_id = data.unifi_port_profile.all.id
    }
}

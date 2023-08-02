resource "unifi_device" "switch_e_livingroom" {
    mac      = "70:a7:41:7e:33:da"
    name     = "Switch E Livingroom"
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



resource "unifi_device" "switch_living_room" {
    mac      = "d0:21:f9:de:ac:39"
    name     = "Switch Livingroom"
    site     = "default"
    port_override {
        name            = "Homematic Raspi GW"
        number          = 1
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NUC 4"
        number          = 2
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Lora AP"
        number          = 4
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Switch Alicia"
        number          = 7
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Switch Livingroom TV"
        number          = 8
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NUC 3-up"
        number          = 9
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NUC 3-down"
        number          = 10
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NUC 2-up"
        number          = 11
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NUC 2-down"
        number          = 12
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NUC 1-up"
        number          = 13
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NUC 1-down"
        number          = 14
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NAS-up"
        number          = 15
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NAS-down"
        number          = 16
        #port_profile_id = data.unifi_port_profile.all.id
    }
}



resource "unifi_device" "switch_livingroom_tv" {
    mac      = "68:d7:9a:4f:0f:9d"
    name     = "Switch Livingroom TV"
    site     = "default"
    port_override {
        name            = "Switch Livingroom"
        number          = 1
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Chromecast"
        number          = 2
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "FireTV"
        number          = 3
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Table TV"
        number          = 4
        #port_profile_id = data.unifi_port_profile.all.id
    }
}

resource "unifi_device" "switch_living_room" {
    mac      = "d0:21:f9:de:ac:39"
    name     = "Switch Livingroom"
    site     = "default"
    port_override {
        name            = "Homematic Raspi GW"
        number          = 1
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NUC 4"
        number          = 2
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Lora AP"
        number          = 4
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Switch Alicia"
        number          = 7
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Switch Livingroom TV"
        number          = 8
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NUC 3-up"
        number          = 9
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NUC 3-down"
        number          = 10
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NUC 2-up"
        number          = 11
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NUC 2-down"
        number          = 12
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NUC 1-up"
        number          = 13
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NUC 1-down"
        number          = 14
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NAS-up"
        number          = 15
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "NAS-down"
        number          = 16
        port_profile_id = data.unifi_port_profile.all.id
    }
}

resource "unifi_device" "switch_workroom" {
    mac      = "d0:21:f9:de:ac:ab"
    name     = "Switch Workroom"
    site     = "default"
    port_override {
        name            = "Switch Guestroom"
        number          = 1
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Switch Workroom PC Right"
        number          = 2
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Switch Alicia"
        number          = 3
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Base Table Right"
        number          = 4
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Switch Workroom PC Left"
        number          = 6
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Base Table Left"
        number          = 8
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Desktop Right"
        number          = 12
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Desktop Left"
        number          = 14
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Printer"
        number          = 16
        port_profile_id = data.unifi_port_profile.all.id
    }
}

resource "unifi_device" "switch_guestroom" {
    mac      = "24:5a:4c:53:1c:68"
    name     = "Switch Guestroom"
    site     = "default"
    port_override {
        name            = "Switch Guestroom PC"
        number          = 1
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Switch Guestroom Right"
        number          = 2
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "AP Guestroom"
        number          = 3
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Chromecast Ultra"
        number          = 4
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Homematic Gateway"
        number          = 6
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Dragino AP"
        number          = 7
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Switch Workroom"
        number          = 8
        port_profile_id = data.unifi_port_profile.all.id
    }
}

resource "unifi_device" "switch_long_corridor" {
    mac      = "24:5a:4c:53:1c:bc"
    name     = "Switch Long Corridor"
    site     = "default"
    port_override {
        name            = "AP-Kitchen"
        number          = 1
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Switch Kitchen"
        number          = 2
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "AP-Corridor"
        number          = 3
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "AP-Workroom"
        number          = 4
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Fritzbox"
        number          = 5
        port_profile_id = data.unifi_port_profile.fritzbox.id
    }
    port_override {
        name            = "Router"
        number          = 6
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Switch Alicia"
        number          = 8
        port_profile_id = data.unifi_port_profile.all.id
    }
}

resource "unifi_device" "long_corridor_ap" {
    mac      = "68:d7:9a:3a:85:4b"
    name     = "AP Long Corridor"
    site     = "default"
}

resource "unifi_device" "ap_guestroom" {
    mac      = "24:5a:4c:6e:c2:dd"
    name     = "AP Guestroom"
    site     = "default"
}

resource "unifi_device" "ap_kitchen" {
    mac      = "24:5a:4c:6e:dd:61"
    name     = "AP Kitchen"
    site     = "default"
}

resource "unifi_device" "ap_workroom" {
    mac      = "24:5a:4c:6e:d5:19"
    name     = "AP Workroom"
    site     = "default"
}

resource "unifi_device" "switch_guestroom_door" {
    mac      = "68:d7:9a:4f:0f:71"
    name     = "Switch Guestroom Door"
    site     = "default"
    port_override {
      name            = "Switch Guestroom"
      number          = 1
      port_profile_id = data.unifi_port_profile.all.id
    }
}

resource "unifi_device" "switch_livingroom_tv" {
    mac      = "68:d7:9a:4f:0f:9d"
    name     = "Switch Livingroom TV"
    site     = "default"
    port_override {
        name            = "Switch Livingroom"
        number          = 1
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Chromecast"
        number          = 2
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "FireTV"
        number          = 3
        port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Table TV"
        number          = 4
        port_profile_id = data.unifi_port_profile.all.id
    }
}

resource "unifi_device" "switch_guestroom_pc" {
    mac      = "68:d7:9a:4f:0f:b7"
    name     = "Switch Guestroom PC"
    site     = "default"
    port_override {
      name            = "Switch Guestroom"
      number          = 1
      port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
      name            = "Desktop PC"
      number          = 2
      port_profile_id = data.unifi_port_profile.all.id
    }
}

resource "unifi_device" "switch_workroom_pc_right" {
    mac      = "68:d7:9a:4f:0f:b9"
    name     = "Switch Workroom PC Right"
    site     = "default"
    port_override {
      name            = "Switch Workroom"
      number          = 1
      port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
      name            = "Raspberry"
      number          = 2
      port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
      name            = "Port replicator"
      number          = 5
      port_profile_id = data.unifi_port_profile.all.id
    }
}

resource "unifi_device" "switch_workroom_pc_left" {
    mac      = "68:d7:9a:4f:0f:d4"
    name     = "Switch Workroom PC Left"
    site     = "default"
    port_override {
      name            = "Switch Workroom"
      number          = 1
      port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
      name            = "Port Replicator"
      number          = 2
      port_profile_id = data.unifi_port_profile.all.id
    }
}

resource "unifi_device" "switch_alicia" {
    mac      = "74:ac:b9:ae:76:a5"
    name     = "Switch Alicia"
    site     = "default"
    
    port_override {
      name            = "Switch Livingroom"
      number          = 1
      port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
      name            = "Switch Corridor"
      number          = 2
      port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
      name            = "Switch Workroom"
      number          = 3
      port_profile_id = data.unifi_port_profile.all.id
    }
}

resource "unifi_device" "switch_kitchen" {
    mac      = "24:5a:4c:53:1b:db"
    name     = "Switch Kitchen"
    site     = "default"
    port_override {
      name            = "Homematic AP"
      number          = 1
      port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
      name            = "Homematic GW"
      number          = 6
      port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
      name            = "LTE Router"
      number          = 7
      port_profile_id = data.unifi_port_profile.lte.id
    }
    port_override {
      name            = "Switch Long Corridor"
      number          = 8
      port_profile_id = data.unifi_port_profile.all.id
    }
}
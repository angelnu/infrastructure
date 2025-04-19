resource "unifi_device" "switch_e_workroom" {
    mac      = "70:a7:41:7a:8a:91"
    name     = "Switch E Workroom"
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
        name                = "Long corridor"
        number              = 9
        op_mode             = "aggregate"
        aggregate_num_ports = 2
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Long corridor"
        number          = 10
        #port_profile_id = data.unifi_port_profile.all.id
    }
}



resource "unifi_device" "switch_workroom" {
    mac      = "24:5a:4c:53:1c:68"
    name     = "Switch Workroom"
    site     = "default"
    port_override {
        name            = "Switch Guestroom PC"
        number          = 1
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Switch Guestroom Right"
        number          = 2
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "AP Guestroom"
        number          = 3
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Chromecast Ultra"
        number          = 4
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Homematic Gateway"
        number          = 6
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Dragino AP"
        number          = 7
        #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
        name            = "Switch Workroom"
        number          = 8
        #port_profile_id = data.unifi_port_profile.all.id
    }
}



resource "unifi_device" "switch_workroom_pc_right" {
    mac      = "68:d7:9a:4f:0f:b9"
    name     = "Switch Workroom PC Right"
    site     = "default"
    port_override {
      name            = "Switch Workroom"
      number          = 1
      #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
      name            = "Raspberry"
      number          = 2
      #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
      name            = "Port replicator"
      number          = 5
      #port_profile_id = data.unifi_port_profile.all.id
    }
}



resource "unifi_device" "switch_workroom_pc_left" {
    mac      = "68:d7:9a:4f:0f:d4"
    name     = "Switch Workroom PC Left"
    site     = "default"
    port_override {
      name            = "Switch Workroom"
      number          = 1
      #port_profile_id = data.unifi_port_profile.all.id
    }
    port_override {
      name            = "Port Replicator"
      number          = 2
      #port_profile_id = data.unifi_port_profile.all.id
    }
}

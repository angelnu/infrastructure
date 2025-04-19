resource "unifi_device" "switch_e_livingroom" {
  mac  = "70:a7:41:7e:33:da"
  name = "Switch E Livingroom"
  site = "default"
  port_override {
    name   = "TBD"
    number = 1
    #aggregate_num_ports = 0
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "TBD"
    number = 2
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "TBD"
    number = 3
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "TBD"
    number = 4
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "TBD"
    number = 5
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "TBD"
    number = 6
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "TBD"
    number = 7
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "TBD"
    number = 8
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name                = "TBD"
    number              = 9
    aggregate_num_ports = 2
    op_mode             = "aggregate"
    #port_profile_id = data.unifi_port_profile.all.id
  }
  # port_override {
  #     name            = "TBD"
  #     number          = 10
  #     aggregate_num_ports = 0
  #     #port_profile_id = data.unifi_port_profile.all.id
  # }
}



resource "unifi_device" "switch_living_room" {
  mac  = "9c:05:d6:5e:cd:c6"
  name = "Switch Livingroom Backup"
  site = "default"
  port_override {
    name   = "TBD"
    number = 1
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "TBD"
    number = 2
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "TBD"
    number = 4
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "TBD"
    number = 5
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "Alicia"
    number = 6
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "TV Livingroom"
    number = 7
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "Switch E Livingroom"
    number = 8
    #port_profile_id = data.unifi_port_profile.all.id
  }
}



resource "unifi_device" "switch_livingroom_tv" {
  mac  = "68:d7:9a:4f:0f:9d"
  name = "Switch Livingroom TV"
  site = "default"
  port_override {
    name   = "Switch Livingroom"
    number = 1
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "Chromecast"
    number = 2
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "FireTV"
    number = 3
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "Table TV"
    number = 4
    #port_profile_id = data.unifi_port_profile.all.id
  }
}

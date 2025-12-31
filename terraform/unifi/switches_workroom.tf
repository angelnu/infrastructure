resource "unifi_device" "switch_e_workroom" {
  mac  = "70:a7:41:7a:8a:91"
  name = "Switch E Workroom"
  site = "default"
  port_override {
    name   = "Switch workroom"
    number = 1
  }
  port_override {
    name   = "Right Base - right port"
    number = 2
  }
  port_override {
    name   = "Left Base - right port"
    number = 3
  }
  port_override {
    name   = "Switch Alicia"
    number = 4
  }
  port_override {
    name   = "Desktop Right"
    number = 5
  }
  port_override {
    name   = "Desktop Left"
    number = 6
  }
  port_override {
    name   = "Hub Left"
    number = 7
  }
  port_override {
    name   = "Hub Right"
    number = 8
  }
  port_override {
    name    = "Switch E Long Corridor"
    number  = 9
    op_mode = "aggregate"
  }

  # Terraform provider does not support new aggregation API
  # port_override {
  #   name                = "Long corridor"
  #   number              = 9
  #   op_mode             = "aggregate"
  #   aggregate_num_ports = 2
  #   #port_profile_id = data.unifi_port_profile.all.id
  # }
  # port_override {
  #   name   = "Long corridor"
  #   number = 10
  #   #port_profile_id = data.unifi_port_profile.all.id
  # }
}



resource "unifi_device" "switch_workroom" {
  mac  = "24:5a:4c:53:1c:68"
  name = "Switch Workroom"
  site = "default"
  port_override {
    name   = "Switch Guestroom"
    number = 1
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "Right Base - left port"
    number = 2
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "Left Base - left port"
    number = 3
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "Empty"
    number = 4
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "Empty"
    number = 5
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "Empty"
    number = 6
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "Printer"
    number = 7
    #port_profile_id = data.unifi_port_profile.all.id
  }
  port_override {
    name   = "Switch Workroom"
    number = 8
    #port_profile_id = data.unifi_port_profile.all.id
  }
}



resource "unifi_device" "switch_workroom_pc_right" {
  mac  = "68:d7:9a:4f:0f:b9"
  name = "Switch Workroom PC Right"
  site = "default"
  port_override {
    name   = "Switch E Workroom"
    number = 1
  }
  port_override {
    name   = "Port replicator"
    number = 5
  }
}



resource "unifi_device" "switch_workroom_pc_left" {
  mac  = "68:d7:9a:4f:0f:d4"
  name = "Switch Workroom PC Left"
  site = "default"
  port_override {
    name   = "Switch E Workroom"
    number = 1
  }
}

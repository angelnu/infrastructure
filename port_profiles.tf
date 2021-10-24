data "unifi_port_profile" "all" {
}

data "unifi_port_profile" "lan" {
    name= "LAN"
}

data "unifi_port_profile" "lte" {
    name= "lte"
}
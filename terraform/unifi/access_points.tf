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

resource "unifi_device" "ap_pueblo_galeria" {
    mac      = "60:22:32:ff:32:25"
    name     = "Pueblo AP Galeria"
    site     = "default"
    forget_on_destroy = true
}

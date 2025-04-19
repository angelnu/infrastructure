resource "unifi_user_group" "default" {
  name              = "Default"
  qos_rate_max_down = -1
  qos_rate_max_up   = -1
}
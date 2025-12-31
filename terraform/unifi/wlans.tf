resource "unifi_wlan" "casa" {
  ap_group_ids = [
    data.unifi_ap_group.default.id,
  ]
  hide_ssid                 = false
  is_guest                  = false
  l2_isolation              = false
  mac_filter_enabled        = false
  mac_filter_policy         = "deny"
  minimum_data_rate_2g_kbps = 1000
  minimum_data_rate_5g_kbps = 6000
  multicast_enhance         = false
  name                      = "casa"
  network_id                = data.unifi_network.LAN.id
  no2ghz_oui                = true
  passphrase                = var.unifi_wlan_password
  pmf_mode                  = "required"
  security                  = "wpapsk"
  site                      = "default"
  uapsd                     = true
  user_group_id             = unifi_user_group.default.id
  wpa3_support              = true
  wpa3_transition           = false
}

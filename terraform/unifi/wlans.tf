resource "unifi_wlan" "casa" {
    ap_group_ids              = [
        data.unifi_ap_group.default.id,
    ]
    hide_ssid                 = false
    is_guest                  = false
    l2_isolation              = false
    mac_filter_enabled        = false
    mac_filter_list           = []
    mac_filter_policy         = "deny"
    minimum_data_rate_2g_kbps = 0
    minimum_data_rate_5g_kbps = 0
    multicast_enhance         = false
    name                      = "casa"
    network_id                = unifi_network.LAN.id
    no2ghz_oui                = true
    passphrase                = var.unifi_wlan_password
    pmf_mode                  = "optional"
    security                  = "wpapsk"
    site                      = "default"
    uapsd                     = true
    user_group_id             = unifi_user_group.default.id
    wlan_band                 = "both"
    wpa3_support              = true
    wpa3_transition           = true
}
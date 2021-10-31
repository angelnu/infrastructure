module "unifi" {
  source = "./unifi"

  unifi_api_url = var.unifi_api_url
  unifi_api_insecure = var.unifi_api_insecure
  unifi_api_username = var.unifi_api_username
  unifi_api_password = var.unifi_api_password
  unifi_wlan_password = var.unifi_wlan_password
}

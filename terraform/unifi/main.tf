terraform {
  required_providers {
    unifi = {
      source = "paultyng/unifi"
      version = "0.38.1"
    }
  }
}

provider "unifi" {
  username = var.unifi_api_username # optionally use UNIFI_USERNAME env var
  password = var.unifi_api_password # optionally use UNIFI_PASSWORD env var
  api_url  = var.unifi_api_url  # optionally use UNIFI_API env var

  # you may need to allow insecure TLS communications unless you have configured
  # certificates for your controller
  allow_insecure = var.unifi_api_insecure # optionally use UNIFI_INSECURE env var

  # if you are not configuring the default site, you can change the site
  # site = "foo" or optionally use UNIFI_SITE env var
}

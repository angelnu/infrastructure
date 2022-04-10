resource "authentik_tenant" "default" {
  domain         = var.main_home_domain
  default        = false
  branding_title   = "Casa"
  branding_logo    = "/static/dist/assets/icons/icon_left_brand.svg"
  branding_favicon = "/static/dist/assets/icons/icon.png"
  flow_authentication = authentik_flow.login.uuid
  flow_recovery       = authentik_flow.recovery.uuid
  flow_invalidation   = authentik_flow.invalidation.uuid
}
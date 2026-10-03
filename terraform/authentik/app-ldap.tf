resource "authentik_provider_ldap" "ldap_app" {
  name        = "ldap-app"
  base_dn     = var.cluster_settings.base_dn
  bind_flow   = authentik_flow.login_headless.uuid
  unbind_flow = authentik_flow.unlogin_headless.uuid
  certificate = data.authentik_certificate_key_pair.cluster_domain_cert.id
  bind_mode   = "direct"
  search_mode = "cached"
  mfa_support = false
}

resource "authentik_application" "ldap_app" {
  name              = "ldap-app"
  slug              = "ldap-app"
  protocol_provider = authentik_provider_ldap.ldap_app.id
}

resource "authentik_token" "ldap_search_maddy" {
  identifier   = "maddy"
  user         = authentik_user.users["ldap"].id
  intent       = "app_password"
  retrieve_key = true
  expiring     = false
}

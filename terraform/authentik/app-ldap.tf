resource "authentik_provider_ldap" "ldap_app" {
  name      = "ldap-app"
  base_dn   = var.authentik_ldap_base_dn
  bind_flow = data.authentik_flow.default-authentication-flow.id
}

resource "authentik_application" "ldap_app" {
  name              = "ldap-app"
  slug              = "ldap-app"
  protocol_provider = authentik_provider_ldap.ldap_app.id
}
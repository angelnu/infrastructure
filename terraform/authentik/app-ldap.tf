resource "authentik_provider_ldap" "ldap_app" {
  name      = "ldap-app"
  base_dn   = var.authentik_ldap_base_dn
  bind_flow = data.authentik_flow.default-authentication-flow.id
  search_group = authentik_group.groups["ldap_search"].id
  certificate = data.authentik_certificate_key_pair.cluster_domain_cert.id
}

resource "authentik_application" "ldap_app" {
  name              = "ldap-app"
  slug              = "ldap-app"
  protocol_provider = authentik_provider_ldap.ldap_app.id
}
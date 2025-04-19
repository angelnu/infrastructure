resource "authentik_provider_ldap" "ldap_app" {
  name        = "ldap-app"
  base_dn     = var.authentik_config.apps.ldap.base_dn
  bind_flow   = authentik_flow.login_headless.uuid
  unbind_flow = authentik_flow.unlogin_headless.uuid
  #search_group = authentik_group.groups["ldap_search"].id
  certificate = data.authentik_certificate_key_pair.cluster_domain_cert.id
}

resource "authentik_application" "ldap_app" {
  name              = "ldap-app"
  slug              = "ldap-app"
  protocol_provider = authentik_provider_ldap.ldap_app.id
}
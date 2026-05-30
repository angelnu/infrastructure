resource "authentik_provider_saml" "nextcloud" {
  name                          = "nextcloud"
  authorization_flow            = authentik_flow.authorization_implicit_consent.uuid
  invalidation_flow             = authentik_flow.invalidation.uuid
  acs_url                       = "https://nextcloud.${var.cluster_short_domain}/apps/user_saml/saml/acs"
  issuer                        = ""
  sp_binding                    = "post"
  audience                      = "https://nextcloud.${var.cluster_short_domain}/apps/user_saml/saml/metadata"
  property_mappings             = data.authentik_property_mapping_provider_saml.default.ids
  signing_kp                    = data.authentik_certificate_key_pair.generated.id
  session_valid_not_on_or_after = "hours=24"
}

resource "authentik_application" "nextcloud" {
  name              = "nextcloud"
  slug              = "nextcloud"
  protocol_provider = authentik_provider_saml.nextcloud.id
}

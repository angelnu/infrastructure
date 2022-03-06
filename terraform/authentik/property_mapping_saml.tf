data "authentik_property_mapping_saml" "default" {
  managed_list = [
    "goauthentik.io/providers/saml/upn",
    "goauthentik.io/providers/saml/uid",
    "goauthentik.io/providers/saml/username",
    "goauthentik.io/providers/saml/ms-windowsaccountname",
    "goauthentik.io/providers/saml/name",
    "goauthentik.io/providers/saml/email",
    "goauthentik.io/providers/saml/groups",
  ]
}

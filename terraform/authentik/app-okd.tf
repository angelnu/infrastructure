resource "authentik_provider_oauth2" "okd" {
  name                   = "okd"
  sub_mode               = "user_email"
  client_id              = "okd"
  client_secret          = var.authentik_config.apps.okd.client_secret
  authentication_flow    = authentik_flow.login.uuid
  authorization_flow     = authentik_flow.authorization_implicit_consent.uuid
  invalidation_flow      = authentik_flow.invalidation.uuid
  property_mappings      = data.authentik_property_mapping_provider_scope.oauth2.ids
  signing_key            = data.authentik_certificate_key_pair.generated.id
  access_token_validity  = "hours=24"
  refresh_token_validity = "days=30"
  allowed_redirect_uris = [
    {
      matching_mode = "strict",
      url           = "https://oauth-openshift.apps.${var.cluster_domain}/oauth2callback/Casa96"
    }
  ]
}

resource "authentik_application" "okd" {
  name              = "okd app"
  slug              = "okd-app"
  protocol_provider = authentik_provider_oauth2.okd.id
  meta_launch_url   = "https://console-openshift-console.apps.${var.cluster_domain}"
}

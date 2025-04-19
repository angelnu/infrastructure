resource "authentik_provider_oauth2" "gitea" {
  name                   = "gitea"
  client_id              = "gitea"
  client_secret          = var.authentik_config.apps.gitea.client_secret
  authentication_flow    = authentik_flow.login.uuid
  authorization_flow     = authentik_flow.authorization_implicit_consent.uuid
  invalidation_flow      = authentik_flow.invalidation.uuid
  property_mappings      = data.authentik_property_mapping_provider_scope.oauth2.ids
  signing_key            = data.authentik_certificate_key_pair.generated.id
  access_token_validity  = "hours=1"
  refresh_token_validity = "days=30"
  allowed_redirect_uris = [
    {
      matching_mode = "strict",
      url           = "https://git.${var.main_home_domain}/user/oauth2/authentik/callback"
    }
  ]
}

resource "authentik_application" "gitea" {
  name              = "gitea app"
  slug              = "gitea-app"
  protocol_provider = authentik_provider_oauth2.gitea.id
  meta_launch_url   = "https://git.${var.main_home_domain}"
}
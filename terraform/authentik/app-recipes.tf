resource "authentik_provider_oauth2" "recipes" {
  name                   = "recipes"
  client_id              = "recipes"
  client_secret          = var.authentik_config.apps.recipes.client_secret
  authorization_flow     = authentik_flow.authorization_implicit_consent.uuid
  invalidation_flow      = authentik_flow.invalidation.uuid
  access_token_validity  = "hours=1"
  refresh_token_validity = "days=30"
  allowed_redirect_uris  = [
    {
      matching_mode = "strict",
      url           = "https://recipes.pub.${var.main_home_domain}/accounts/authentik/login/callback/"
    }
  ]
}

resource "authentik_application" "recipes" {
  name              = "recipes"
  slug              = "recipes"
  protocol_provider = authentik_provider_oauth2.recipes.id
  meta_launch_url   = "https://recipes.pub.${var.main_home_domain}"
}
resource "authentik_provider_oauth2" "flux" {
  name                       = "flux"
  sub_mode                   = "user_email"
  client_id                  = "flux"
  client_type                = "confidential"
  client_secret              = var.authentik_config.apps.flux.client_secret
  authentication_flow        = authentik_flow.login.uuid
  authorization_flow         = authentik_flow.authorization_implicit_consent.uuid
  invalidation_flow          = authentik_flow.invalidation.uuid
  property_mappings          = data.authentik_property_mapping_provider_scope.oauth2.ids
  signing_key                = data.authentik_certificate_key_pair.generated.id
  include_claims_in_id_token = true
  access_token_validity      = "hours=24"
  refresh_token_validity     = "days=30"
  allowed_redirect_uris = [
    {
      matching_mode = "strict"
      url           = "https://flux.pub.${var.cluster_domain}/oauth2/callback"
    }
  ]
  authorization_flows = [
    authentik_flow.login.uuid,                          # Handles Authorization Code / Password / Client Credentials
    authentik_flow.authorization_implicit_consent.uuid, # Handles Implicit / Hybrid handshakes
  ]
}

resource "authentik_application" "flux" {
  name              = "flux app"
  slug              = "flux-app"
  protocol_provider = authentik_provider_oauth2.flux.id
  meta_launch_url   = "https://flux.pub.${var.cluster_domain}"
}

# Look up your standard login flow
data "authentik_flow" "login" {
  slug = "default-authentication-flow" # Change this if you use a custom login flow slug
}

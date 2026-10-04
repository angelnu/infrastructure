resource "authentik_property_mapping_provider_scope" "groups" {
  name       = "oauth2-scope-groups"
  scope_name = "groups"
  expression = <<-EOT
return {
  "groups": [group.name for group in request.user.groups.all()],
}
EOT
}

resource "authentik_provider_oauth2" "home_assistant" {
  name                = "home-assistant"
  client_id           = "home-assistant"
  client_secret       = var.authentik_config.apps.home_assistant.client_secret
  sub_mode            = "user_username"
  authentication_flow = authentik_flow.login.uuid
  authorization_flow  = authentik_flow.authorization_implicit_consent.uuid
  invalidation_flow   = authentik_flow.invalidation.uuid
  grant_types         = ["authorization_code", "refresh_token"]
  property_mappings = concat(
    data.authentik_property_mapping_provider_scope.oauth2.ids,
    [authentik_property_mapping_provider_scope.groups.id]
  )
  signing_key            = data.authentik_certificate_key_pair.generated.id
  access_token_validity  = "hours=24"
  refresh_token_validity = "days=30"
  allowed_redirect_uris = [
    { matching_mode = "strict", url = "https://ha.${var.cluster_short_domain}/auth/oidc/callback" },
    { matching_mode = "strict", url = "https://ha.pub.${var.cluster_domain}/auth/oidc/callback" },
    { matching_mode = "strict", url = "https://ha.home.${var.cluster_domain}/auth/oidc/callback" },
  ]
}

resource "authentik_application" "home_assistant" {
  name              = "Home Assistant"
  slug              = "home-assistant"
  protocol_provider = authentik_provider_oauth2.home_assistant.id
  meta_launch_url   = "https://ha.${var.cluster_short_domain}"
  meta_description  = "Home automation (OIDC SSO)"
}

resource "authentik_policy_binding" "home_assistant_app_access" {
  target  = authentik_application.home_assistant.uuid
  group   = authentik_group.groups["default_ingress"].id
  order   = 0
  timeout = 1440
}

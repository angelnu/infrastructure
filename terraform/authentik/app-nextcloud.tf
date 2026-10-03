resource "authentik_provider_oauth2" "nextcloud" {
  name                   = "nextcloud"
  sub_mode               = "user_email"
  client_id              = "nextcloud"
  client_secret          = var.authentik_config.apps.okd.client_secret
  authentication_flow    = authentik_flow.login.uuid
  authorization_flow     = authentik_flow.authorization_implicit_consent.uuid
  invalidation_flow      = authentik_flow.invalidation.uuid
  property_mappings = concat(
    data.authentik_property_mapping_provider_scope.oauth2.ids,
    [authentik_property_mapping_provider_scope.nextcloud_profile.id]
  )
  signing_key            = data.authentik_certificate_key_pair.generated.id
  access_token_validity  = "hours=24"
  refresh_token_validity = "days=30"
  grant_types = [
    "authorization_code",
    "refresh_token"
  ]
  allowed_redirect_uris = [
    {
      
      matching_mode     = "strict"
      redirect_uri_type = "authorization"
      url               = "https://nextcloud.${var.cluster_short_domain}/index.php/apps/user_oidc/code"
    },
    {

      matching_mode     = "strict"
      redirect_uri_type = "authorization"
      url               = "https://nextcloud.${var.cluster_short_domain}/apps/user_oidc/code"
    }
  ]
}

resource "authentik_application" "nextcloud" {
  name              = "nextcloud app"
  slug              = "nextcloud-app"
  protocol_provider = authentik_provider_oauth2.nextcloud.id
  meta_launch_url   = "https://nextcloud.${var.cluster_short_domain}"
}

resource "authentik_property_mapping_provider_scope" "nextcloud_profile" {
  name       = "Nextcloud Claims Mapping"
  scope_name = "nextcloud"
  expression = <<EOF
# Extract default or user/group-specific quota, fallback to 10 TB
quota = request.user.attributes.get("app_entitlements_attributes", "1 TB")

return {
    "sub": request.user.username,
    "name": request.user.name,
    "email": request.user.email,
    "groups": [g.name for g in request.user.ak_groups.all()],
    "quota": quota,
    "user_id": request.user.username,
}
EOF
}

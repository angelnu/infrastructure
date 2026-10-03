locals {
  paperless_instances = ["", "javi", "edu", "madrid", "mireille-work", "recipes", "alicia", "daniel"]
}

resource "authentik_provider_oauth2" "paperless" {
  name                   = "paperless"
  client_id              = "paperless"
  client_secret          = var.authentik_config.apps.paperless.client_secret
  authorization_flow     = authentik_flow.authorization_implicit_consent.uuid
  invalidation_flow      = authentik_flow.invalidation.uuid
  property_mappings = concat(
    data.authentik_property_mapping_provider_scope.oauth2_custom_profile.ids,
    [authentik_property_mapping_provider_scope.paperless_profile.id]
  )
  signing_key            = data.authentik_certificate_key_pair.generated.id
  sub_mode               = "user_username"
  access_token_validity  = "hours=1"
  refresh_token_validity = "days=30"
  grant_types = [
    "authorization_code",
    "refresh_token"
  ]
  allowed_redirect_uris = [
    for instance in local.paperless_instances : {
      matching_mode     = "strict"
      redirect_uri_type = "authorization"
      url = format(
        "https://%s.pub.%s/accounts/oidc/casa/login/callback/",
        instance == "" ? "paperless" : "paperless-${instance}",
        var.cluster_domain,
      )
    }
  ]
}

resource "authentik_application" "paperless" {
  name              = "paperless"
  slug              = "paperless"
  protocol_provider = authentik_provider_oauth2.paperless.id
  meta_launch_url   = "https://paperless.pub.${var.cluster_domain}"
}

resource "authentik_property_mapping_provider_scope" "paperless_profile" {
  name       = "Paperless custom profile scope"
  scope_name = "profile"
  expression = <<-EOT
    name = request.user.name or ""
    parts = name.split(" ", 1)
    return {
        "name": name,
        "given_name": parts[0],
        "family_name": parts[1] if len(parts) > 1 else "",
        "preferred_username": request.user.username,
        "nickname": request.user.username,
        "groups": [group.name for group in request.user.ak_groups.all()],
    }
  EOT
}

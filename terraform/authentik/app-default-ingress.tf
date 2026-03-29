resource "authentik_provider_proxy" "default_ingress" {
  name                   = "default-ingress-proxy"
  mode                   = "forward_domain"
  authorization_flow     = authentik_flow.authorization_implicit_consent.uuid
  invalidation_flow      = authentik_flow.invalidation.uuid
  external_host          = "https://authentik.pub.${var.cluster_domain}"
  cookie_domain          = var.cluster_short_domain
  access_token_validity  = var.authentik_config.sessions.access_token_duration
  refresh_token_validity = var.authentik_config.sessions.refresh_token_duration
}

resource "authentik_application" "default_ingress" {
  name              = "default ingress"
  slug              = "default-ingress-app"
  protocol_provider = authentik_provider_proxy.default_ingress.id
}

resource "authentik_policy_binding" "default_ingress_app_access" {
  target  = authentik_application.default_ingress.uuid
  group   = authentik_group.groups["default_ingress"].id
  order   = 0
  timeout = 1440
}


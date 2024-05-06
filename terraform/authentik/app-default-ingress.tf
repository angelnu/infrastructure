resource "authentik_provider_proxy" "default_ingress" {
  name                   = "default-ingress-proxy"
  mode                   = "forward_domain"
  authorization_flow     = authentik_flow.authorization_implicit_consent.uuid
  external_host          = "https://authentik.pub.${var.main_home_domain}"
  cookie_domain          = var.main_home_domain
  access_token_validity  = "hours=1"
  refresh_token_validity = "days=30"
}

resource "authentik_application" "default_ingress" {
  name              = "default ingress"
  slug              = "default-ingress-app"
  protocol_provider = authentik_provider_proxy.default_ingress.id
}

resource "authentik_policy_binding" "default_ingress_app_access" {
  target = authentik_application.default_ingress.uuid
  group  = authentik_group.groups["default_ingress"].id
  order  = 0
}


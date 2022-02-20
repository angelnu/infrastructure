resource "authentik_provider_proxy" "kubernetes_dashboard" {
  name               = "kubernetes-dashboard-proxy"
  mode               = "forward_single"
  authorization_flow = authentik_flow.authorization_implicit_consent.uuid
  external_host      = "https://dashboard.${var.main_home_domain}"
  #cookie_domain      = var.main_home_domain
  #token_validity     = "days=30"
}

resource "authentik_application" "kubernetes_dashboard" {
  name              = "kubernetes dashboard app"
  slug              = "kubernetes-dashboard-app"
  protocol_provider = authentik_provider_proxy.kubernetes_dashboard.id
}

resource "authentik_policy_binding" "kubernetes_dashboard_app_access" {
  target = authentik_application.kubernetes_dashboard.uuid
  group  = authentik_group.groups["admins"].id
  order  = 0
}


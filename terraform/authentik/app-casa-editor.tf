resource "authentik_provider_proxy" "ha_editor" {
  name               = "ha-editor-proxy"
  mode               = "forward_single"
  authorization_flow = authentik_flow.authorization_implicit_consent.uuid
  external_host      = "https://ha-editor.pub.${var.main_home_domain}"
  #token_validity     = "days=30"
}

resource "authentik_application" "ha_editor" {
  name              = "ha editors"
  slug              = "ha-editor-app"
  protocol_provider = authentik_provider_proxy.ha_editor.id
}

resource "authentik_policy_binding" "ha_editor_app_access" {
  target = authentik_application.ha_editor.uuid
  group  = authentik_group.groups["casa-editors"].id
  order  = 0
}


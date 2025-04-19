resource "authentik_flow" "login_headless" {
  name               = "terraform-login-headless"
  title              = "casa headless"
  slug               = "terraform-login-headless"
  background         = "/static/dist/assets/images/flow_background.jpg"
  designation        = "authentication"
  compatibility_mode = true
}

resource "authentik_flow_stage_binding" "login_headless_identification" {
  target = authentik_flow.login_headless.uuid
  stage  = authentik_stage_identification.identification.id
  order  = 10
}

# Should we deny if reputation is low?

# Only DUO is supported
resource "authentik_flow_stage_binding" "login_headless_validate" {
  target = authentik_flow.login_headless.uuid
  stage  = authentik_stage_authenticator_validate.validate.id
  order  = 30
}

resource "authentik_flow_stage_binding" "login_headless_user_login" {
  target = authentik_flow.login_headless.uuid
  stage  = authentik_stage_user_login.user_login.id
  order  = 100
}

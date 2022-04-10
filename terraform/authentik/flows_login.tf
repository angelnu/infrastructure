resource "authentik_flow" "login" {
  name        = "terraform-login"
  title       = "Welcome to Casa!"
  slug        = "terraform-login"
  background  = "/static/dist/assets/images/flow_background.jpg" 
  designation = "authentication"
  compatibility_mode = true
}

resource "authentik_flow_stage_binding" "login_identification" {
  target = authentik_flow.login.uuid
  stage  = authentik_stage_identification.identification.id
  order  = 10
}

resource "authentik_flow_stage_binding" "login_captcha" {
  target = authentik_flow.login.uuid
  stage  = authentik_stage_captcha.captcha.id
  order  = 20
}

resource "authentik_policy_binding" "logincaptcha-reputation" {
  target = authentik_flow_stage_binding.login_captcha.id
  policy = authentik_policy_reputation.reputation.id
  order  = 0
}

resource "authentik_flow_stage_binding" "login_validate" {
  target = authentik_flow.login.uuid
  stage  = authentik_stage_authenticator_validate.validate.id
  order  = 30
}

resource "authentik_flow_stage_binding" "login_user_login" {
  target = authentik_flow.login.uuid
  stage  = authentik_stage_user_login.user_login.id
  order  = 100
}

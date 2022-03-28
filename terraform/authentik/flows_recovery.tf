resource "authentik_flow" "recovery" {
  name        = "terraform-recovery"
  title       = "Casa - password recovery"
  slug        = "terraform-recovery"
  background  = "/static/dist/assets/images/flow_background.jpg" 
  designation = "recovery"
}

resource "authentik_flow_stage_binding" "recovery_identification" {
  target = authentik_flow.recovery.uuid
  stage  = authentik_stage_identification.identification_no_password.id
  order  = 10
}

resource "authentik_flow_stage_binding" "recovery_verification_email" {
  target = authentik_flow.recovery.uuid
  stage  = authentik_stage_email.verification_email.id
  order  = 20
}

resource "authentik_flow_stage_binding" "recovery_promt" {
  target = authentik_flow.recovery.uuid
  stage  = authentik_stage_prompt.password_change.id
  order  = 30
}

resource "authentik_flow_stage_binding" "recovery_user_write" {
  target = authentik_flow.recovery.uuid
  stage  = authentik_stage_user_write.user_write.id
  order  = 40
}

resource "authentik_flow_stage_binding" "recovery_user_login" {
  target = authentik_flow.recovery.uuid
  stage  = authentik_stage_user_login.user_login.id
  order  = 100
}
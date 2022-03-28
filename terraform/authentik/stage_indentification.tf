resource "authentik_stage_identification" "identification" {
  name           = "terraform-identification"
  user_fields    = ["username","email"]
  #sources        = ["authentik.core.auth.InbuiltBackend"]
  password_stage = authentik_stage_password.password.id
  recovery_flow  = authentik_flow.recovery.uuid
  case_insensitive_matching = true
}

resource "authentik_stage_identification" "identification_no_password" {
  name           = "terraform-identification-no-password"
  user_fields    = ["username","email"]
  #sources        = ["authentik.core.auth.InbuiltBackend"]
  case_insensitive_matching = true
}
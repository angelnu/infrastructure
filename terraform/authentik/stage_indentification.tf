resource "authentik_stage_identification" "identification" {
  name           = "terraform-identification"
  user_fields    = ["username","email"]
  #sources        = ["authentik.core.auth.InbuiltBackend"]
  password_stage = authentik_stage_password.password.id
  recovery_flow   = authentik_flow.recovery.uuid
}
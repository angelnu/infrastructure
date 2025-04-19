resource "authentik_stage_identification" "identification" {
  name                      = "terraform-identification"
  user_fields               = ["username", "email"]
  sources                   = [data.authentik_source.inbuilt.uuid]
  password_stage            = authentik_stage_password.password.id
  recovery_flow             = authentik_flow.recovery.uuid
  case_insensitive_matching = true
}

resource "authentik_stage_identification" "identification_no_password" {
  name                      = "terraform-identification-no-password"
  user_fields               = ["username", "email"]
  case_insensitive_matching = true
}
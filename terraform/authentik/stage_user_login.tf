resource "authentik_stage_user_login" "user_login" {
  name             = "user-login"
  #session_duration = "seconds=0"
  session_duration = "hours=12"
}
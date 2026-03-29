resource "authentik_stage_user_login" "user_login" {
  name = "user-login"
  #session_duration = "seconds=0"
  session_duration = var.authentik_config.sessions.access_token_duration
  remember_device  = var.authentik_config.sessions.refresh_token_duration
}

resource "authentik_stage_email" "verification_email" {
  name     = "terraform-email-verification"
  template = "email/password_reset.html"
  subject = "Authentik password recovery"
  timeout  = 30
  token_expiry = 30
  use_global_settings = true
}
resource "authentik_stage_password" "password" {
  name     = "terraform-password"
  backends = ["authentik.core.auth.InbuiltBackend", "authentik.core.auth.TokenBackend"]
}
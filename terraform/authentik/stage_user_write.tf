resource "authentik_stage_user_write" "user_write" {
  name                     = "terraform-user-write"
  create_users_as_inactive = false
}
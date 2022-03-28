resource "authentik_stage_prompt_field" "password" {
  field_key   = "password"
  label       = "Password"
  type        = "password"
  required    = true
  order       = 0
}
resource "authentik_stage_prompt_field" "password_repeat" {
  field_key   = "password_repeat"
  label       = "Password"
  type        = "password"
  placeholder = "Password (repeat)"
  required    = true
  order       = 1
}

resource "authentik_stage_prompt" "password_change" {
  name = "terraform_password_change"
  fields = [
    resource.authentik_stage_prompt_field.password.id,
    resource.authentik_stage_prompt_field.password_repeat.id,
  ]
}
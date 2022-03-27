resource "authentik_stage_captcha" "captcha" {
  name        = "terraform-captcha"
  private_key = var.authentik_config.captcha.private_key
  public_key  = var.authentik_config.captcha.public_key
}
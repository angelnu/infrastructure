resource "authentik_flow" "recovery" {
  name        = "terraform-recovery"
  title       = "Casa - password recovery"
  slug        = "terraform-recovery"
  background  = "/static/dist/assets/images/flow_background.jpg" 
  designation = "recovery"
}
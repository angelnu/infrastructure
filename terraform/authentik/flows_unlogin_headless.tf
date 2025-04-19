resource "authentik_flow" "unlogin_headless" {
  name        = "terraform-unlogin-headless"
  title       = "Casa - unlogin headless"
  slug        = "terraform-unlogin-headless"
  background  = "/static/dist/assets/images/flow_background.jpg" 
  designation = "invalidation"
}

resource "authentik_flow_stage_binding" "unbind_user_unlogin_headless" {
  target = authentik_flow.unlogin_headless.uuid
  stage  = authentik_stage_user_logout.user_logout.id
  order  = 10
}
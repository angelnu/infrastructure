resource "authentik_flow" "invalidation" {
  name        = "terraform-invalidation"
  title       = "Casa - logout"
  slug        = "terraform-invalidation"
  background  = "/static/dist/assets/images/flow_background.jpg"
  designation = "invalidation"
}

resource "authentik_flow_stage_binding" "invalidation_user_logout" {
  target = authentik_flow.invalidation.uuid
  stage  = authentik_stage_user_logout.user_logout.id
  order  = 10
}
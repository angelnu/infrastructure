resource "authentik_flow" "unenrollment" {
  name        = "terraform-unenrollment"
  title       = "Casa - logout"
  slug        = "terraform-unenrollment"
  background  = "/static/dist/assets/images/flow_background.jpg" 
  designation = "unenrollment"
}

resource "authentik_flow_stage_binding" "unenrollment_user_logout" {
  target = authentik_flow.unenrollment.uuid
  stage  = authentik_stage_user_logout.user_logout.id
  order  = 10
}